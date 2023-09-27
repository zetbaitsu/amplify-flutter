// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0

import 'package:actions/actions.dart';
import 'package:actions/src/deputy/post_update_task.dart';
import 'package:actions/src/logger.dart';
import 'package:actions/src/node/platform.dart';
import 'package:actions/src/node/process_manager.dart';
import 'package:aft_common/aft_common.dart';
import 'package:aws_common/aws_common.dart';
import 'package:node_io/node_io.dart';
import 'package:pub_semver/pub_semver.dart';

/// Scans for outdated Dart and Flutter dependencies and creates PRs for version updates.
Future<void> main() => wrapMain(_deputyScan);

/// The list of dependencies to never update.
const List<String> _doNotUpdate = [
  // TODO(aft): Remove when min Flutter SDK allows latest xml
  // Updating xml will require changes in smithy.
  'xml',

  // Bumping leads to mismatched `analyzer` constraint with `built_value_generator`
  // Must always match stable since it's what `dart format` uses.
  'dart_style',

  // Breaking change would need to be coordinated
  'uuid',
];

Future<void> _deputyScan() async {
  final logger = AWSLogger().createChild('Deputy')
    ..unregisterAllPlugins()
    ..registerPlugin(const NodeLoggerPlugin());
  final deputy = await Deputy.create(
    dependencyGroups: DependencyUpdateGroup.all,
    fileSystem: nodeFileSystem,
    platform: nodePlatform,
    processManager: nodeProcessManager,
    logger: logger,
  );
  final updates = await core.withGroup(
    'Scan for Updates',
    deputy.scanForUpdates,
  );
  if (updates == null) {
    return core.info('No updates needed');
  }

  await allocateSwapSpace();
  await createPrs(deputy.repo, updates);
}

/// Lists all Deputy PRs which currently exist in the repo with the PR number
/// and the constraint
Future<Map<String, int>> _listExistingPrs() async {
  final octokit = github.getOctokit(process.getEnv('GITHUB_TOKEN')!);
  return core.withGroup('Check for existing PRs', () async {
    final existingPrs = <String, int>{};
    final pulls = await octokit.rest.pulls.list();
    for (final pull in pulls) {
      final commitMessage =
          CommitMessage.parse('', pull.title, body: pull.body);
      final trailers = commitMessage.trailers;
      final groupName = trailers['Updated-Group'];
      if (groupName == null) {
        continue;
      }
      existingPrs[groupName] = pull.number;
    }
    core.info('Found existing PRs: $existingPrs');
    return existingPrs;
  });
}

/// Creates a PR for each dependency group, closing existing PRs which are superceded.
Future<void> createPrs(
  Repo repo,
  Map<String, DependencyGroupUpdate> updates,
) async {
  final git = NodeGitDir(repo.git);
  final tmpDir = nodeFileSystem.systemTempDirectory.createTempSync('deputy');
  final existingPrs = await _listExistingPrs();
  core.info('Creating PRs for update groups: $updates');
  for (final MapEntry(key: groupName, value: group) in updates.entries) {
    // If the group updates all deps to a unique constraint, use that in messages.
    final uniqueConstraint =
        group.updatedConstraints.values.toSet().singleOrNull;
    await core.withGroup('Create PR for group "$groupName"', () async {
      if (group.dependencies.any(_doNotUpdate.contains)) {
        core.info(
          'Skipping "$groupName" since one of its dependencies are on the do-not-update list',
        );
        return;
      }

      // Update pubspecs for the dependency and commit changes to a new branch.
      //
      // We create a new worktree to stage changes so that we are not switching
      // branches for each group and interfering with the current checkout.
      core.info('Creating new worktree...');
      // TODO(dnys1): Fix
      // const baseBranch = 'origin/main';
      const baseBranch = 'origin/chore/aft-fixes';
      var branchName = 'chore/deps/$groupName';
      if (uniqueConstraint != null) {
        final constraint = uniqueConstraint
            .toString()
            .replaceAll(_specialChars, '')
            .replaceAll(' ', '-');
        branchName += '-$constraint';
      } else {
        branchName += '-${DateTime.now().millisecondsSinceEpoch}';
      }
      final worktreeDir = nodeFileSystem.systemTempDirectory
          .createTempSync('worktree_$groupName')
          .path;
      await git.runCommand([
        'worktree',
        'add',
        worktreeDir,
        '-b',
        branchName,
        baseBranch,
      ]);
      final worktreeRepo = await Repo.load(
        path: worktreeDir,
        processManager: nodeProcessManager,
        fileSystem: nodeFileSystem,
        platform: nodePlatform,
        logger: repo.logger,
      );
      final worktree = NodeGitDir(worktreeRepo.git);

      core.info('Updating pubspecs...');
      await group.updatePubspecs(worktreeRepo);

      core.info('Running post-update tasks...');
      await group.runPostUpdateTasks(worktreeRepo);

      core.info('Diffing changes...');
      await worktree.runCommand(['diff']);

      core.info('Committing changes...');
      var commitTitle = 'chore(deps): Bump $groupName';
      if (uniqueConstraint != null) {
        commitTitle += ' to $uniqueConstraint';
      }
      commitTitle = '"$commitTitle"';
      await worktree.runCommand(['add', '-A']);
      await worktree.runCommand(['commit', '-m', commitTitle]);
      await worktree.runCommand(['push', '-f', '-u', 'origin', branchName]);

      // Create a PR for the changes using the `gh` CLI.
      core.info('Creating PR...');
      final constraintUpdates = group.dependencies
          .map(
            (dependency) =>
                '- Updated `$dependency` to `${group.updatedConstraints[dependency]}`',
          )
          .join('\n');
      final prBody = '''
> **NOTE:** This PR was automatically created using the repo deputy.

Updated $groupName:
$constraintUpdates

Updated-Group: $groupName
''';
      final tmpFile = tmpDir.childFile('pr_body_$groupName.txt')
        ..createSync()
        ..writeAsStringSync(prBody);
      final prResult = await nodeProcessManager.run(
        <String>[
          'gh',
          'pr',
          'create',
          '--base=main',
          '--body-file=${tmpFile.path}',
          '--title=$commitTitle',
        ],
        echoOutput: true,
        workingDirectory: worktreeDir,
      );
      if (prResult.exitCode != 0) {
        core.error(
          'Failed to create PR (${prResult.exitCode}): ${prResult.stderr}',
        );
        process.exitCode = 1;
        return;
      }

      // Close existing PR if this supercedes.
      final existingPr = existingPrs[groupName];
      if (existingPr == null) {
        return;
      }

      core.info('Closing existing PR...');
      final closeResult = await nodeProcessManager.run(
        <String>[
          'gh',
          'pr',
          'close',
          '$existingPr',
          '--comment="Closing in favor of new PR."',
        ],
        echoOutput: true,
        workingDirectory: worktreeDir,
      );
      if (closeResult.exitCode != 0) {
        core.error(
          'Failed to close existing PR. Will need to be closed manually: '
          'https://github.com/aws-amplify/amplify-flutter/pull/$existingPr',
        );
        process.exitCode = 1;
        return;
      }
    });
  }
}

/// Special characters which appear in stringified [VersionConstraint]s.
final _specialChars = RegExp(r'[\^<>=]');

extension type NodeGitDir(GitDir it) implements GitDir {
  Future<void> runCommand(List<String> args) => it.runCommand(
    args, 
    stdout: stdout.writeln, 
    stderr: stderr.writeln,
  );
}

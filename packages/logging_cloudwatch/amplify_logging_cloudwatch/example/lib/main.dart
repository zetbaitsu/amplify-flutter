import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_logging_cloudwatch_example/amplifyconfiguration.dart';
import 'package:amplify_logging_cloudwatch_example/amplifyconfiguration_logging.dart';
import 'package:amplify_logging_cloudwatch_example/homepage.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authPlugin = AmplifyAuthCognito();

  final amplifyConfigWithLogging = AmplifyConfig.fromJson(
    jsonDecode(amplifyconfig) as Map<String, dynamic>,
  ).copyWith(
    logging: LoggingConfig.fromJson(
      jsonDecode(loggingconfig) as Map<String, dynamic>,
    ),
  );

  final amplifyConfig =
      const JsonEncoder().convert(amplifyConfigWithLogging.toJson());

  await Amplify.addPlugin(authPlugin);
  await Amplify.configure(amplifyConfig);

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) {
            return InitPage(
              key: GlobalKey(),
              title: 'Amplify Logging Cloudwatch Example',
            );
          },
          '/home': (BuildContext context) {
            return MyHomePage(
              key: GlobalKey(),
              title: 'Amplify Logging Cloudwatch Example',
            );
          },
          '/login': (BuildContext context) {
            return AuthenticatedView(
              child: MyHomePage(
                key: GlobalKey(),
                title: 'Amplify Logging Cloudwatch Example',
              ),
            );
          },
        },
      ),
    );
  }
}

class InitPage extends StatelessWidget {
  const InitPage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    Amplify.Auth.signOut();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              style: TextStyle(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
              'You are signed-out.\n\nclick on "GO to Login Page" to login or create a user.\n\nclick on "GO to Home Page" to enter as a guest.\n\n\n\n',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Go to Login Page'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: const Text('Go to Home Page'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
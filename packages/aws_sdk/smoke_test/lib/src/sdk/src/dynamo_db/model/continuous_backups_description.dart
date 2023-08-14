// Generated with smithy-dart 0.3.1. DO NOT MODIFY.
// ignore_for_file: avoid_unused_constructor_parameters,deprecated_member_use_from_same_package,non_constant_identifier_names,require_trailing_commas

library smoke_test.dynamo_db.model.continuous_backups_description; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:aws_common/aws_common.dart' as _i1;
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:smithy/smithy.dart' as _i2;
import 'package:smoke_test/src/sdk/src/dynamo_db/model/continuous_backups_status.dart';
import 'package:smoke_test/src/sdk/src/dynamo_db/model/point_in_time_recovery_description.dart';

part 'continuous_backups_description.g.dart';

/// Represents the continuous backups and point in time recovery settings on the table.
abstract class ContinuousBackupsDescription
    with
        _i1.AWSEquatable<ContinuousBackupsDescription>
    implements
        Built<ContinuousBackupsDescription,
            ContinuousBackupsDescriptionBuilder> {
  /// Represents the continuous backups and point in time recovery settings on the table.
  factory ContinuousBackupsDescription({
    required ContinuousBackupsStatus continuousBackupsStatus,
    PointInTimeRecoveryDescription? pointInTimeRecoveryDescription,
  }) {
    return _$ContinuousBackupsDescription._(
      continuousBackupsStatus: continuousBackupsStatus,
      pointInTimeRecoveryDescription: pointInTimeRecoveryDescription,
    );
  }

  /// Represents the continuous backups and point in time recovery settings on the table.
  factory ContinuousBackupsDescription.build(
          [void Function(ContinuousBackupsDescriptionBuilder) updates]) =
      _$ContinuousBackupsDescription;

  const ContinuousBackupsDescription._();

  static const List<_i2.SmithySerializer<ContinuousBackupsDescription>>
      serializers = [ContinuousBackupsDescriptionAwsJson10Serializer()];

  /// `ContinuousBackupsStatus` can be one of the following states: ENABLED, DISABLED
  ContinuousBackupsStatus get continuousBackupsStatus;

  /// The description of the point in time recovery settings applied to the table.
  PointInTimeRecoveryDescription? get pointInTimeRecoveryDescription;
  @override
  List<Object?> get props => [
        continuousBackupsStatus,
        pointInTimeRecoveryDescription,
      ];
  @override
  String toString() {
    final helper = newBuiltValueToStringHelper('ContinuousBackupsDescription')
      ..add(
        'continuousBackupsStatus',
        continuousBackupsStatus,
      )
      ..add(
        'pointInTimeRecoveryDescription',
        pointInTimeRecoveryDescription,
      );
    return helper.toString();
  }
}

class ContinuousBackupsDescriptionAwsJson10Serializer
    extends _i2.StructuredSmithySerializer<ContinuousBackupsDescription> {
  const ContinuousBackupsDescriptionAwsJson10Serializer()
      : super('ContinuousBackupsDescription');

  @override
  Iterable<Type> get types => const [
        ContinuousBackupsDescription,
        _$ContinuousBackupsDescription,
      ];
  @override
  Iterable<_i2.ShapeId> get supportedProtocols => const [
        _i2.ShapeId(
          namespace: 'aws.protocols',
          shape: 'awsJson1_0',
        )
      ];
  @override
  ContinuousBackupsDescription deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContinuousBackupsDescriptionBuilder();
    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final value = iterator.current;
      if (value == null) {
        continue;
      }
      switch (key) {
        case 'ContinuousBackupsStatus':
          result.continuousBackupsStatus = (serializers.deserialize(
            value,
            specifiedType: const FullType(ContinuousBackupsStatus),
          ) as ContinuousBackupsStatus);
        case 'PointInTimeRecoveryDescription':
          result.pointInTimeRecoveryDescription
              .replace((serializers.deserialize(
            value,
            specifiedType: const FullType(PointInTimeRecoveryDescription),
          ) as PointInTimeRecoveryDescription));
      }
    }

    return result.build();
  }

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ContinuousBackupsDescription object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result$ = <Object?>[];
    final ContinuousBackupsDescription(
      :continuousBackupsStatus,
      :pointInTimeRecoveryDescription
    ) = object;
    result$.addAll([
      'ContinuousBackupsStatus',
      serializers.serialize(
        continuousBackupsStatus,
        specifiedType: const FullType(ContinuousBackupsStatus),
      ),
    ]);
    if (pointInTimeRecoveryDescription != null) {
      result$
        ..add('PointInTimeRecoveryDescription')
        ..add(serializers.serialize(
          pointInTimeRecoveryDescription,
          specifiedType: const FullType(PointInTimeRecoveryDescription),
        ));
    }
    return result$;
  }
}

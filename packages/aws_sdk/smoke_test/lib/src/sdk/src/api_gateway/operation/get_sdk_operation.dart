// Generated with smithy-dart 0.3.1. DO NOT MODIFY.
// ignore_for_file: avoid_unused_constructor_parameters,deprecated_member_use_from_same_package,non_constant_identifier_names,require_trailing_commas

library smoke_test.api_gateway.operation.get_sdk_operation; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i6;
import 'dart:typed_data' as _i2;

import 'package:aws_common/aws_common.dart' as _i5;
import 'package:aws_signature_v4/aws_signature_v4.dart' as _i3;
import 'package:smithy/smithy.dart' as _i1;
import 'package:smithy_aws/smithy_aws.dart' as _i4;
import 'package:smoke_test/src/sdk/src/api_gateway/common/endpoint_resolver.dart';
import 'package:smoke_test/src/sdk/src/api_gateway/common/serializers.dart';
import 'package:smoke_test/src/sdk/src/api_gateway/model/bad_request_exception.dart';
import 'package:smoke_test/src/sdk/src/api_gateway/model/conflict_exception.dart';
import 'package:smoke_test/src/sdk/src/api_gateway/model/get_sdk_request.dart';
import 'package:smoke_test/src/sdk/src/api_gateway/model/limit_exceeded_exception.dart';
import 'package:smoke_test/src/sdk/src/api_gateway/model/not_found_exception.dart';
import 'package:smoke_test/src/sdk/src/api_gateway/model/sdk_response.dart';
import 'package:smoke_test/src/sdk/src/api_gateway/model/too_many_requests_exception.dart';
import 'package:smoke_test/src/sdk/src/api_gateway/model/unauthorized_exception.dart';

/// Generates a client SDK for a RestApi and Stage.
class GetSdkOperation extends _i1.HttpOperation<GetSdkRequestPayload,
    GetSdkRequest, _i2.Uint8List, SdkResponse> {
  /// Generates a client SDK for a RestApi and Stage.
  GetSdkOperation({
    required String region,
    Uri? baseUri,
    _i3.AWSCredentialsProvider credentialsProvider =
        const _i3.AWSCredentialsProvider.defaultChain(),
    List<_i1.HttpRequestInterceptor> requestInterceptors = const [],
    List<_i1.HttpResponseInterceptor> responseInterceptors = const [],
  })  : _region = region,
        _baseUri = baseUri,
        _credentialsProvider = credentialsProvider,
        _requestInterceptors = requestInterceptors,
        _responseInterceptors = responseInterceptors;

  @override
  late final List<
      _i1.HttpProtocol<GetSdkRequestPayload, GetSdkRequest, _i2.Uint8List,
          SdkResponse>> protocols = [
    _i4.RestJson1Protocol(
      serializers: serializers,
      builderFactories: builderFactories,
      requestInterceptors: <_i1.HttpRequestInterceptor>[
            const _i1.WithHost(),
            const _i1.WithNoHeader('Content-Length'),
            const _i1.WithNoHeader('Content-Type'),
            _i4.WithSigV4(
              region: _region,
              service: _i5.AWSService.apiGateway,
              credentialsProvider: _credentialsProvider,
            ),
            const _i1.WithUserAgent('aws-sdk-dart/0.3.1'),
            const _i4.WithSdkInvocationId(),
            const _i4.WithSdkRequest(),
            const _i1.WithHeader(
              'Accept',
              'application/json',
            ),
          ] +
          _requestInterceptors,
      responseInterceptors:
          <_i1.HttpResponseInterceptor>[] + _responseInterceptors,
    )
  ];

  late final _i4.AWSEndpoint _awsEndpoint = endpointResolver.resolve(
    sdkId,
    _region,
  );

  final String _region;

  final Uri? _baseUri;

  final _i3.AWSCredentialsProvider _credentialsProvider;

  final List<_i1.HttpRequestInterceptor> _requestInterceptors;

  final List<_i1.HttpResponseInterceptor> _responseInterceptors;

  @override
  _i1.HttpRequest buildRequest(GetSdkRequest input) => _i1.HttpRequest((b) {
        b.method = 'GET';
        b.path = r'/restapis/{restApiId}/stages/{stageName}/sdks/{sdkType}';
        if (input.parameters != null) {
          for (var entry in input.parameters!.toMap().entries) {
            b.queryParameters.add(
              entry.key,
              entry.value,
            );
          }
        }
      });
  @override
  int successCode([SdkResponse? output]) => 200;
  @override
  SdkResponse buildOutput(
    _i2.Uint8List? payload,
    _i5.AWSBaseHttpResponse response,
  ) =>
      SdkResponse.fromResponse(
        payload,
        response,
      );
  @override
  List<_i1.SmithyError> get errorTypes => const [
        _i1.SmithyError<BadRequestException, BadRequestException>(
          _i1.ShapeId(
            namespace: 'com.amazonaws.apigateway',
            shape: 'BadRequestException',
          ),
          _i1.ErrorKind.client,
          BadRequestException,
          statusCode: 400,
          builder: BadRequestException.fromResponse,
        ),
        _i1.SmithyError<ConflictException, ConflictException>(
          _i1.ShapeId(
            namespace: 'com.amazonaws.apigateway',
            shape: 'ConflictException',
          ),
          _i1.ErrorKind.client,
          ConflictException,
          statusCode: 409,
          builder: ConflictException.fromResponse,
        ),
        _i1.SmithyError<LimitExceededExceptionPayload, LimitExceededException>(
          _i1.ShapeId(
            namespace: 'com.amazonaws.apigateway',
            shape: 'LimitExceededException',
          ),
          _i1.ErrorKind.client,
          LimitExceededException,
          statusCode: 429,
          builder: LimitExceededException.fromResponse,
        ),
        _i1.SmithyError<NotFoundException, NotFoundException>(
          _i1.ShapeId(
            namespace: 'com.amazonaws.apigateway',
            shape: 'NotFoundException',
          ),
          _i1.ErrorKind.client,
          NotFoundException,
          statusCode: 404,
          builder: NotFoundException.fromResponse,
        ),
        _i1.SmithyError<TooManyRequestsExceptionPayload,
            TooManyRequestsException>(
          _i1.ShapeId(
            namespace: 'com.amazonaws.apigateway',
            shape: 'TooManyRequestsException',
          ),
          _i1.ErrorKind.client,
          TooManyRequestsException,
          statusCode: 429,
          builder: TooManyRequestsException.fromResponse,
        ),
        _i1.SmithyError<UnauthorizedException, UnauthorizedException>(
          _i1.ShapeId(
            namespace: 'com.amazonaws.apigateway',
            shape: 'UnauthorizedException',
          ),
          _i1.ErrorKind.client,
          UnauthorizedException,
          statusCode: 401,
          builder: UnauthorizedException.fromResponse,
        ),
      ];
  @override
  String get runtimeTypeName => 'GetSdk';
  @override
  _i4.AWSRetryer get retryer => _i4.AWSRetryer();
  @override
  Uri get baseUri => _baseUri ?? endpoint.uri;
  @override
  _i1.Endpoint get endpoint => _awsEndpoint.endpoint;
  @override
  _i1.SmithyOperation<SdkResponse> run(
    GetSdkRequest input, {
    _i5.AWSHttpClient? client,
    _i1.ShapeId? useProtocol,
  }) {
    return _i6.runZoned(
      () => super.run(
        input,
        client: client,
        useProtocol: useProtocol,
      ),
      zoneValues: {
        ...?_awsEndpoint.credentialScope?.zoneValues,
        ...{_i5.AWSHeaders.sdkInvocationId: _i5.uuid(secure: true)},
      },
    );
  }
}

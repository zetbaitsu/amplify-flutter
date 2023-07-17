// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provisioned_throughput_exceeded_exception.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProvisionedThroughputExceededException
    extends ProvisionedThroughputExceededException {
  @override
  final String? message;
  @override
  final int? statusCode;
  @override
  final Map<String, String>? headers;

  factory _$ProvisionedThroughputExceededException(
          [void Function(ProvisionedThroughputExceededExceptionBuilder)?
              updates]) =>
      (new ProvisionedThroughputExceededExceptionBuilder()..update(updates))
          ._build();

  _$ProvisionedThroughputExceededException._(
      {this.message, this.statusCode, this.headers})
      : super._();

  @override
  ProvisionedThroughputExceededException rebuild(
          void Function(ProvisionedThroughputExceededExceptionBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProvisionedThroughputExceededExceptionBuilder toBuilder() =>
      new ProvisionedThroughputExceededExceptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProvisionedThroughputExceededException &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }
}

class ProvisionedThroughputExceededExceptionBuilder
    implements
        Builder<ProvisionedThroughputExceededException,
            ProvisionedThroughputExceededExceptionBuilder> {
  _$ProvisionedThroughputExceededException? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  int? _statusCode;
  int? get statusCode => _$this._statusCode;
  set statusCode(int? statusCode) => _$this._statusCode = statusCode;

  Map<String, String>? _headers;
  Map<String, String>? get headers => _$this._headers;
  set headers(Map<String, String>? headers) => _$this._headers = headers;

  ProvisionedThroughputExceededExceptionBuilder() {
    ProvisionedThroughputExceededException._init(this);
  }

  ProvisionedThroughputExceededExceptionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _statusCode = $v.statusCode;
      _headers = $v.headers;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProvisionedThroughputExceededException other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProvisionedThroughputExceededException;
  }

  @override
  void update(
      void Function(ProvisionedThroughputExceededExceptionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProvisionedThroughputExceededException build() => _build();

  _$ProvisionedThroughputExceededException _build() {
    final _$result = _$v ??
        new _$ProvisionedThroughputExceededException._(
            message: message, statusCode: statusCode, headers: headers);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
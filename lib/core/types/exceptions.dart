part of core.types;

abstract class LighthouseException implements Exception {
  final String msg;
  const LighthouseException(this.msg);
}

abstract class VaultException extends LighthouseException {
  const VaultException(super.msg);
}

abstract class LighthouseObjectException extends LighthouseException {
  const LighthouseObjectException(String msg) : super(msg);
}

abstract class UtilityException extends LighthouseException {
  const UtilityException(super.msg);
}

abstract class DBError extends LighthouseException {
  final int statusCode;
  final JSON request;
  const DBError(this.request, msg, this.statusCode) : super(msg);

  static DBError? fromJSON(JSON json) {
    switch (json['code']) {
      case 400:
        return BadRequest_400(json['request'], json['msg'], json['statusCode']);
      case 503:
        return ServiceUnavailable_503(
            json['request'], json['msg'], json['statusCode']);
      default:
        return null;
    }
  }
}

class BadRequest_400 extends DBError {
  const BadRequest_400(super.request, super.msg, super.statusCode);
}

class ServiceUnavailable_503 extends DBError {
  const ServiceUnavailable_503(super.request, super.msg, super.statusCode);
}

class ObjectNotFound extends VaultException {
  final String obejctId;
  const ObjectNotFound(this.obejctId)
      : super("Requested Lighthouse Object does not exist in cache.");
}

class OverwrittenObjectTypeMismatch extends VaultException {
  final String objectId;
  final Type requiredType;
  final Type givenType;
  const OverwrittenObjectTypeMismatch(
      this.objectId, this.requiredType, this.givenType)
      : super(
            "Lighthouse Object cannot be overwritten by a a Lighthouse Object of different type.");
}

class InvalidType extends LighthouseObjectException {
  final String objectId;
  final dynamic inferenceSource;
  const InvalidType(this.objectId, this.inferenceSource)
      : super(
            "Could not detect the type of the Lighthouse Object as it is invalid.");
}

class TypeCastError extends UtilityException {
  final Type fromType;
  final Type toType;
  const TypeCastError(this.fromType, this.toType, super.msg);
}

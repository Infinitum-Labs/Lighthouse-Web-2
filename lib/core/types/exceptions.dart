part of core.types;

abstract class LighthouseException implements Exception {
  final String msg;
  const LighthouseException(this.msg);
}

abstract class VaultException extends LighthouseException {
  const VaultException(String msg) : super(msg);
}

abstract class LighthouseObjectException extends LighthouseException {
  const LighthouseObjectException(String msg) : super(msg);
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

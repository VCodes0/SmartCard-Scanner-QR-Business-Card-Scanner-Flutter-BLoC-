/// Base class for all failures in the application
abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

/// Scanner-related failures
class ScannerFailure extends Failure {
  const ScannerFailure(super.message);
}

/// Contact operation failures
class ContactFailure extends Failure {
  const ContactFailure(super.message);
}

/// Permission-related failures
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// Network or parsing failures
class ParseFailure extends Failure {
  const ParseFailure(super.message);
}

/// Camera-related failures
class CameraFailure extends Failure {
  const CameraFailure(super.message);
}

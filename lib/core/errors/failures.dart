/// Base class for all failures in the application
abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

/// Failure for server/API errors
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure for network connectivity errors
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Failure for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}

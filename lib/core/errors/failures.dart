abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "No internet connection"]);
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    String message = "Server error",
    this.statusCode,
  }) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure({String message = "Cache error"}) : super(message);
}

class UnknownFailure extends Failure {
  const UnknownFailure({String message = "Unknown error"}) : super(message);
}
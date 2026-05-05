abstract class AppException implements Exception {
  final String message;
  final String? prefix;

  const AppException({required this.message, this.prefix});

  @override
  String toString() {
    return "${prefix ?? 'Excetion'}: $message";
  }
}

//====================
// Network Exceptions
//====================

class NetworkException extends AppException {
  const NetworkException({
    super.message = "No internet connection. Please check your network.",
  }) : super(prefix: "NetworkException");
}

class TimeoutException extends AppException {
  const TimeoutException({
    super.message = "Request timeout. Please try again later.",
  }) : super(prefix: "TimeoutException");
}

//==========================
// Server Exceptions (API)
// |=> Example
// throw ServerException(
//   message: "Internal Server Error",
//   statusCode: 500,
// );
//==========================
class ServerEception extends AppException {
  final int? statusCode;
  const ServerEception({required super.message, this.statusCode})
    : super(prefix: "ServerException");

  @override
  String toString() {
    return "ServerException (code: $statusCode): $message";
  }
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = "You are not authorized. Please login again.",
  }) : super(prefix: "UnauthorizedException");
}

class ForbiddenException extends AppException {
  const ForbiddenException({super.message = "Access denied."})
    : super(prefix: "ForbiddenException");
}

/// -------------------------
/// Cache / Local Storage
/// -------------------------

class CacheException extends AppException {
  const CacheException({super.message = "Failed to load or save local data."})
    : super(prefix: "CacheException");
}

/// -------------------------
/// Data / Parsing Exceptions
/// -------------------------

class ParsingException extends AppException {
  const ParsingException({super.message = "Error parsing data from server."})
    : super(prefix: "ParsingException");
}

/// -------------------------
/// Validation Exceptions
/// -------------------------

class ValidationException extends AppException {
  final Map<String, String>? errors;

  const ValidationException({super.message = "Validation failed.", this.errors})
    : super(prefix: "ValidationException");

  @override
  String toString() {
    return "ValidationException: $message ${errors ?? ''}";
  }
}

/// -------------------------
/// Unknown Exception
/// -------------------------

class UnknownException extends AppException {
  const UnknownException({
    super.message = "Something went wrong. Please try again.",
  }) : super(prefix: "UnknownException");
}

/// Base exception class for Shapes API errors
abstract class ShapesApiException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const ShapesApiException(
    this.message, {
    this.code,
    this.details,
  });

  @override
  String toString() {
    if (code != null) {
      return 'ShapesApiException[$code]: $message';
    }
    return 'ShapesApiException: $message';
  }
}

/// Exception thrown when authentication fails
class ShapesApiAuthenticationException extends ShapesApiException {
  const ShapesApiAuthenticationException(
    String message, {
    String? code,
    dynamic details,
  }) : super(message, code: code, details: details);

  @override
  String toString() {
    if (code != null) {
      return 'ShapesApiAuthenticationException[$code]: $message';
    }
    return 'ShapesApiAuthenticationException: $message';
  }
}

/// Exception thrown when rate limits are exceeded
class ShapesApiRateLimitException extends ShapesApiException {
  final Duration? retryAfter;

  const ShapesApiRateLimitException(
    String message, {
    String? code,
    this.retryAfter,
    dynamic details,
  }) : super(message, code: code, details: details);

  @override
  String toString() {
    final base = super.toString();
    if (retryAfter != null) {
      return '$base (Retry after: ${retryAfter!.inSeconds} seconds)';
    }
    return base;
  }
}

/// Exception thrown when the API is unavailable
class ShapesApiUnavailableException extends ShapesApiException {
  const ShapesApiUnavailableException(
    String message, {
    String? code,
    dynamic details,
  }) : super(message, code: code, details: details);

  @override
  String toString() {
    if (code != null) {
      return 'ShapesApiUnavailableException[$code]: $message';
    }
    return 'ShapesApiUnavailableException: $message';
  }
}

/// Exception thrown when a shape is not found
class ShapeNotFoundException extends ShapesApiException {
  final String shapeUsername;

  const ShapeNotFoundException(
    this.shapeUsername, {
    String? code,
    dynamic details,
  }) : super(
          'Shape "$shapeUsername" not found',
          code: code,
          details: details,
        );

  @override
  String toString() {
    if (code != null) {
      return 'ShapeNotFoundException[$code]: Shape "$shapeUsername" not found';
    }
    return 'ShapeNotFoundException: Shape "$shapeUsername" not found';
  }
}

/// Exception thrown when the API key is invalid
class InvalidApiKeyException extends ShapesApiAuthenticationException {
  const InvalidApiKeyException({
    String? code,
    dynamic details,
  }) : super(
          'Invalid API key provided',
          code: code,
          details: details,
        );

  @override
  String toString() {
    if (code != null) {
      return 'InvalidApiKeyException[$code]: Invalid API key provided';
    }
    return 'InvalidApiKeyException: Invalid API key provided';
  }
}

/// Exception thrown when the API key is missing
class MissingApiKeyException extends ShapesApiAuthenticationException {
  const MissingApiKeyException({
    String? code,
    dynamic details,
  }) : super(
          'API key is required but not provided',
          code: code,
          details: details,
        );

  @override
  String toString() {
    if (code != null) {
      return 'MissingApiKeyException[$code]: API key is required but not provided';
    }
    return 'MissingApiKeyException: API key is required but not provided';
  }
}

/// Exception thrown when the request is malformed
class MalformedRequestException extends ShapesApiException {
  final String field;

  const MalformedRequestException(
    this.field, {
    String? code,
    dynamic details,
  }) : super(
          'Malformed request: $field is invalid',
          code: code,
          details: details,
        );

  @override
  String toString() {
    if (code != null) {
      return 'MalformedRequestException[$code]: Malformed request: $field is invalid';
    }
    return 'MalformedRequestException: Malformed request: $field is invalid';
  }
}

/// Exception thrown when the response is invalid
class InvalidResponseException extends ShapesApiException {
  const InvalidResponseException(
    String message, {
    String? code,
    dynamic details,
  }) : super(message, code: code, details: details);

  @override
  String toString() {
    if (code != null) {
      return 'InvalidResponseException[$code]: $message';
    }
    return 'InvalidResponseException: $message';
  }
}

/// Exception thrown when network operations fail
class NetworkException extends ShapesApiException {
  final String? url;
  final int? statusCode;

  const NetworkException(
    String message, {
    String? code,
    this.url,
    this.statusCode,
    dynamic details,
  }) : super(message, code: code, details: details);

  @override
  String toString() {
    final base = super.toString();
    if (url != null && statusCode != null) {
      return '$base (URL: $url, Status: $statusCode)';
    } else if (url != null) {
      return '$base (URL: $url)';
    } else if (statusCode != null) {
      return '$base (Status: $statusCode)';
    }
    return base;
  }
}

/// Exception thrown when timeout occurs
class TimeoutException extends ShapesApiException {
  final Duration timeout;

  const TimeoutException(
    this.timeout, {
    String? code,
    dynamic details,
  }) : super(
          'Request timed out',
          code: code,
          details: details,
        );

  @override
  String toString() {
    if (code != null) {
      return 'TimeoutException[$code]: Request timed out after ${timeout.inSeconds} seconds';
    }
    return 'TimeoutException: Request timed out after ${timeout.inSeconds} seconds';
  }
}

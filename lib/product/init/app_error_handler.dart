import 'package:flutter/foundation.dart';
import 'package:localchess/product/dependency_injection/get.dart';

/// The error handler for the application. Manage global errors.
abstract final class AppErrorHandler {
  /// Initializes the error handling.
  static void init() {
    FlutterError.onError = (details) {
      G.logger.e(
        details.exceptionAsString(),
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      G.logger.e(
        error.toString(),
        error: error,
        stackTrace: stack,
      );

      return true;
    };
  }
}

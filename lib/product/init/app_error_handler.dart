import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/widget/dialog/error_dialog.dart';

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

      _showError(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      G.logger.e(
        error.toString(),
        error: error,
        stackTrace: stack,
      );

      _showError(error);

      return true;
    };
  }

  /// A flag to prevent showing multiple error dialogs.
  static bool _isDialogShowing = false;

  /// Shows the error dialog to the user.
  static void _showError(Object error) {
    final context = G.appRoute.navigatorKey.currentContext;

    if (context != null) {
      if (!_isDialogShowing) {
        _isDialogShowing = true;
        ErrorDialog.show(
          context: context,
          title: LocaleKeys.dialog_errorDialog_title.tr(),
          content: LocaleKeys.dialog_errorDialog_content.tr(
            args: [
              if (error is FlutterErrorDetails)
                error.exceptionAsString()
              else
                error.toString(),
            ],
          ),
          closeText: LocaleKeys.dialog_errorDialog_closeButton.tr(),
        ).then((_) {
          _isDialogShowing = false;
        });
      } else {
        // log if there is an error while showing the error dialog
        G.logger.d(
          'Error dialog cannot be shown to the user. '
          '(There is already a dialog showing)',
          error: (error is FlutterErrorDetails) ? error.exception : error,
        );
      }
    } else {
      // log error if there is no context
      G.logger.e(
        'Error dialog cannot be shown to the user. '
        '(There is no context)',
        error: (error is FlutterErrorDetails) ? error.exception : error,
      );
    }
  }
}

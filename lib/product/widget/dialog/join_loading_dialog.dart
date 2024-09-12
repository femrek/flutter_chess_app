import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/constant/padding/padding_widget_extension.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';

/// Shows a loading dialog while waiting for a promise to complete.
class JoinLoadingDialog extends StatefulWidget {
  /// Creates an instance of [JoinLoadingDialog].
  const JoinLoadingDialog({
    required this.promise,
    super.key,
  });

  /// The promise to wait for.
  final Future<void> promise;

  /// Shows the [JoinLoadingDialog] dialog.
  static Future<void> show({
    required BuildContext context,
    required Future<void> promise,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return JoinLoadingDialog(promise: promise);
      },
    );
  }

  @override
  State<JoinLoadingDialog> createState() => _JoinLoadingDialogState();
}

class _JoinLoadingDialogState extends State<JoinLoadingDialog> {
  final ValueNotifier<bool> _isFinished = ValueNotifier(false);
  final ValueNotifier<bool> _isError = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    widget.promise.then((_) {
      G.logger.i('promise completed');
      _isFinished.value = true;
      if (mounted) context.router.popForced();
    }, onError: (e) {
      G.logger.i('promise completed.onError');
      _isFinished.value = true;
      _isError.value = true;
    });
    // _assignFinishedWhenComplete();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isFinished,
      builder: (context, bool isFinished, child) {
        return PopScope(
          canPop: _isFinished.value,
          onPopInvokedWithResult: (result, _) {
            G.logger.i('pop tried: $result');
          },
          child: child!,
        );
      },
      child: Dialog(
        child: const AppPadding.card().toWidget(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(LocaleKeys.dialog_joinLoadingDialog_title).tr(),
              const SizedBox(height: 12),
              ValueListenableBuilder(
                valueListenable: _isError,
                builder: (context, bool isError, _) {
                  if (isError) {
                    return Text(
                      LocaleKeys.dialog_joinLoadingDialog_error,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ).tr();
                  } else {
                    return const SizedBox(
                      width: 64,
                      height: 64,
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

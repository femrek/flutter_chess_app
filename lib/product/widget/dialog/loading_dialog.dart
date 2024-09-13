import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/constant/padding/padding_widget_extension.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';

/// Show a loading indicator as a dialog.
class LoadingDialog extends StatelessWidget {
  /// Creates the loading dialog.
  const LoadingDialog({super.key});

  /// Shows the loading dialog.
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return const LoadingDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: const AppPadding.card().toWidget(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(LocaleKeys.dialog_joinLoadingDialog_title).tr(),
            const SizedBox(height: 12),
            const SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

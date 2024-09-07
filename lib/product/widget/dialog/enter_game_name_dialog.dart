import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';

/// Dialog for entering a name. The dialog returns the entered text when pop.
class EnterGameNameDialog extends StatefulWidget {
  /// Create an instance for [EnterGameNameDialog].
  const EnterGameNameDialog({
    required this.title,
    required this.hintText,
    required this.confirmText,
    required this.cancelText,
    super.key,
  });

  /// The title of the dialog.
  final String title;

  /// hint text of input field in the dialog.
  final String hintText;

  /// The text of the confirm button.
  final String confirmText;

  /// The text of the cancel button.
  final String cancelText;

  /// Shows the [EnterGameNameDialog] dialog.
  static Future<String?> show({
    required BuildContext context,
    String? title,
    String? hintText,
    String? confirmText,
    String? cancelText,
  }) async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return EnterGameNameDialog(
          title: title ?? LocaleKeys.dialog_createGameDialog_title.tr(),
          hintText: hintText ?? LocaleKeys.dialog_createGameDialog_hint.tr(),
          confirmText: confirmText ??
              LocaleKeys.dialog_createGameDialog_createButton.tr(),
          cancelText: cancelText ??
              LocaleKeys.dialog_createGameDialog_cancelButton.tr(),
        );
      },
    );
    return result;
  }

  @override
  State<EnterGameNameDialog> createState() => _EnterGameNameDialogState();
}

class _EnterGameNameDialogState extends State<EnterGameNameDialog> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.title),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: widget.hintText,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(widget.cancelText),
            ),
            TextButton(
              onPressed: () {
                final enteredText = _nameController.text;
                if (enteredText.isEmpty) return;
                Navigator.of(context).pop(enteredText);
              },
              child: Text(widget.confirmText),
            ),
          ],
        ),
      ],
    );
  }
}

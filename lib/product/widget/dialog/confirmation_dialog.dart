import 'package:flutter/material.dart';

/// A dialog that asks for confirmation. return true if the user confirms.
/// Otherwise, return false.
class ConfirmationDialog extends StatelessWidget {
  /// Create a new instance of [ConfirmationDialog].
  const ConfirmationDialog({
    required this.title,
    required this.confirmText,
    required this.cancelText,
    required this.alert,
    this.content,
    super.key,
  });

  /// The title of the dialog.
  final String title;

  /// The text of the confirm button.
  final String confirmText;

  /// The text of the cancel button.
  final String cancelText;

  /// The content text of the dialog. Optional description.
  final String? content;

  /// The alert flag to show the dialog as an alert dialog.
  final bool alert;

  /// Shows the confirmation dialog with given [title], [content],
  /// [confirmText],
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String confirmText,
    required String cancelText,
    String? content,
    bool alert = true,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return ConfirmationDialog(
              title: title,
              confirmText: confirmText,
              cancelText: cancelText,
              content: content,
              alert: alert,
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final content = this.content;
    return AlertDialog(
      title: Text(title),
      content: content != null ? Text(content) : null,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        if (alert)
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.error,
              ),
            ),
            child: Text(
              confirmText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
          )
        else
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
      ],
    );
  }
}

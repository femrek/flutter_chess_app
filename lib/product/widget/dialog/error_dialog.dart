import 'package:flutter/material.dart';

/// A dialog to show error messages.
class ErrorDialog extends StatefulWidget {
  /// Create an instance of [ErrorDialog].
  const ErrorDialog({
    required this.title,
    required this.content,
    required this.closeText,
    super.key,
  });

  /// The title of the dialog.
  final String title;

  /// The content text of the dialog.
  final String content;

  /// The text of the close button.
  final String closeText;

  /// Shows the [ErrorDialog] dialog.
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    required String closeText,
    Key? key,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return ErrorDialog(
          title: title,
          content: content,
          closeText: closeText,
          key: key,
        );
      },
    );
  }

  @override
  State<ErrorDialog> createState() => ErrorDialogState();
}

/// The state of the [ErrorDialog].
class ErrorDialogState extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(widget.content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(widget.closeText),
        ),
      ],
    );
  }
}

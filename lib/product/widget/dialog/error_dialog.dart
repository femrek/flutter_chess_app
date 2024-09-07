import 'package:flutter/material.dart';

/// A dialog to show error messages.
class ErrorDialog extends StatefulWidget {
  /// Create an instance of [ErrorDialog].
  const ErrorDialog({
    required this.title,
    required this.content,
    required this.closeText,
    // required this.onClosePressed,
    super.key,
  });

  /// The title of the dialog.
  final String title;

  /// The content text of the dialog.
  final String content;

  /// The text of the close button.
  final String closeText;

  /// The callback function to be called when the close button is pressed.
  // final VoidCallback onClosePressed;

  /// Shows the [ErrorDialog] dialog.
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    required String closeText,
    // required VoidCallback onClosePressed,
    Key? key,
  }) async {
    await showDialog<void>(
      context: context,
      // barrierDismissible: false,
      builder: (context) {
        return ErrorDialog(
          title: title,
          content: content,
          closeText: closeText,
          // onClosePressed: onClosePressed,
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
          // onPressed: widget.onClosePressed,
          onPressed: () {
            // widget.onClosePressed();
            Navigator.of(context).pop();
          },
          child: Text(widget.closeText),
        ),
      ],
    );
  }
}

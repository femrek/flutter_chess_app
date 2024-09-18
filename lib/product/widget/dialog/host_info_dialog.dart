import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';

/// Shows the information about the host server. (inet address, port, etc.)
class HostInfoDialog extends StatelessWidget {
  /// Creates a [HostInfoDialog].
  const HostInfoDialog({
    required this.inet,
    required this.port,
    super.key,
  });

  /// The inet address of the host server.
  final String inet;

  /// The port of the host server.
  final int port;

  /// Shows the [HostInfoDialog].
  static Future<void> show({
    required BuildContext context,
    required String inet,
    required int port,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return HostInfoDialog(
          inet: inet,
          port: port,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text(
        LocaleKeys.dialog_hostInfoDialog_title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ).tr(),
      contentPadding: const AppPadding.card(),
      alignment: Alignment.center,
      children: [
        Text(
          LocaleKeys.dialog_hostInfoDialog_hostAddress.tr(args: [
            '$inet:$port',
          ]),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(LocaleKeys.dialog_hostInfoDialog_closeButton.tr()),
            ),
          ],
        ),
      ],
    );
  }
}

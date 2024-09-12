import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/constant/padding/padding_widget_extension.dart';
import 'package:localchess/product/constant/radius/app_radius_constant.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/widget/button/app_button/app_button.dart';

/// The callback when the join button is pressed.
typedef OnJoinPressedWithAddress = void Function(String address, int port);

/// The section for entering the host address to connect.
class SetupJoinHostAddress extends StatefulWidget {
  /// Creates [SetupJoinHostAddress] widget.
  const SetupJoinHostAddress({
    required this.onPressedJoin,
    super.key,
  });

  /// The callback when the join button is pressed.
  final OnJoinPressedWithAddress onPressedJoin;

  @override
  State<SetupJoinHostAddress> createState() => _SetupJoinHostAddressState();
}

class _SetupJoinHostAddressState extends State<SetupJoinHostAddress> {
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _portController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: const AppPadding.card().toWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
            Text(
              LocaleKeys.screen_setupJoin_enterHostAddress_title,
              style: Theme.of(context).textTheme.titleMedium,
            ).tr(),

            const SizedBox(height: 12),

            // input field
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _hostController,
                    decoration: InputDecoration(
                      hintText: LocaleKeys
                          .screen_setupJoin_enterHostAddress_hintHost
                          .tr(),
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(
                          AppRadiusConstant.inputFieldCornerRadius,
                        )),
                      ),
                    ),
                  ),
                ),
                const Text(' : '),
                Expanded(
                  child: TextField(
                    controller: _portController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: LocaleKeys
                          .screen_setupJoin_enterHostAddress_hintPort
                          .tr(),
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(
                          AppRadiusConstant.inputFieldCornerRadius,
                        )),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // join button
            AppButton(
              onPressed: () {
                final address = _hostController.text;
                final port = int.tryParse(_portController.text) ?? 0;
                widget.onPressedJoin(address, port);
              },
              fullWidth: true,
              child: const Text(
                LocaleKeys.screen_setupJoin_enterHostAddress_joinButton,
              ).tr(),
            ),
          ],
        ),
      ),
    );
  }
}

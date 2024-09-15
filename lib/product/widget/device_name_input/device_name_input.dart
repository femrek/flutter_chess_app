import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/constant/padding/padding_widget_extension.dart';
import 'package:localchess/product/constant/radius/app_radius_constant.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';

/// The input section for take a name for the device.
class DeviceNameInput extends StatelessWidget {
  /// Creates the [DeviceNameInput] instance.
  const DeviceNameInput({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  /// The controller for the input field.
  final TextEditingController controller;

  /// The callback when the input field changes.
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: const AppPadding.card().toWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.widget_deviceNameInput_title,
              style: Theme.of(context).textTheme.titleMedium,
            ).tr(),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: LocaleKeys.widget_deviceNameInput_hint.tr(),
                hintStyle: const TextStyle(fontSize: 14),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(
                    AppRadiusConstant.inputFieldCornerRadius,
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

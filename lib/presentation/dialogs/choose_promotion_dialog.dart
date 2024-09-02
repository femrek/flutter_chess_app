import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localchess/utils.dart';

const double _iconSize = 42;

/// shows a dialog to choose the promotion piece. returns the selected piece
/// code. returns null if the dialog is dismissed.
Future<String?> showPromotionDialog(
  BuildContext context,
  List<String> options,
) async {
  return await showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 48,
              alignment: Alignment.center,
              child: Text('Select the promotion'),
            ),
            ScrollConfiguration(
              behavior: GlowsRemovedBehavior(),
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 16),
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context, options[index]);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            height: _iconSize,
                            width: _iconSize,
                            child: SvgPicture.asset(
                              'assets/images/${pieceCodeToAssetName[options[index]]}.svg',
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            child: Text(
                              pieceCodeToAssetName[options[index]] ??
                                  'name could not found',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: options.length,
              ),
            ),
          ],
        ),
      );
    },
  );
}

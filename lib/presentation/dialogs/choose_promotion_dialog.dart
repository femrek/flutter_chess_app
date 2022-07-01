import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localchess/utils.dart';

Future<String> showPromotionDialog(BuildContext context, List<String> options) async {
  String selectedPiece;
  await showDialog(
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
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 16),
                itemBuilder: (_, index) {
                  return IconButton(
                    onPressed: () {
                      selectedPiece = options[index];
                      Navigator.pop(context);
                    },
                    icon: Row(
                      children: [
                        SizedBox(
                          height: 64,
                          width: 64,
                          child: SvgPicture.asset(
                            'assets/images/${pieceCodeToAssetName[options[index]]}.svg',
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Container(
                          child: Text(
                            pieceCodeToAssetName[options[index]],
                            style: TextStyle(
                              fontSize: 22
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, index) {
                  return SizedBox(
                    height: 8,
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
  return selectedPiece;
}

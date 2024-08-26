import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localchess/product/widget/button/app_button/app_button.dart';

void main() {
  group('AppButton', () {
    testWidgets(
      'should display the given text',
      (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: AppButton(
            onPressed: () {},
            child: const Text('Button'),
          ),
        ));

        expect(find.text('Button'), findsOneWidget);
      },
    );

    testWidgets(
      'should call the onPressed callback when the button is pressed',
      (tester) async {
        var isPressed = false;
        await tester.pumpWidget(MaterialApp(
          home: AppButton(
            onPressed: () {
              isPressed = true;
            },
            child: const Text('Button'),
          ),
        ));

        await tester.tap(find.text('Button'));
        expect(isPressed, isTrue);
      },
    );

    testWidgets(
      'should show a loading indicator when the button is pressed '
      'then disappear after the onPressed callback is completed',
      (tester) async {
        var counter = 0;
        await tester.pumpWidget(MaterialApp(
          home: AppButton(
            key: const Key('key_button'),
            onPressed: () async {
              counter++;
              await Future.delayed(const Duration(seconds: 1), () {});
            },
            child: const Text('Button'),
          ),
        ));

        // after tap the button, the loading indicator should be displayed
        await tester.tap(find.byKey(const Key('key_button')));
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(counter, 1);

        // the button should not be able to be pressed
        await tester.tap(find.byKey(const Key('key_button')));
        await tester.pump();
        expect(counter, 1);

        // The button should disappear
        await tester.pump(const Duration(seconds: 1));
        expect(find.byType(CircularProgressIndicator), findsNothing);

        // The button should reappear
        expect(find.text('Button'), findsOneWidget);
      },
    );
  });
}

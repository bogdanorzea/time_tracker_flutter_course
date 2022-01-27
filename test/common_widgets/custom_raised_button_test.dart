import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_raised_button.dart';

void main() {
  testWidgets('onPressed callback', (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: CustomRaisedButton(
          child: Text('Tap me'),
          onPressed: () => pressed = true,
        ),
      ),
    );

    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);
    expect(find.text('Tap me'), findsOneWidget);
    expect(find.byType(TextButton), findsNothing);

    await tester.tap(button);
    expect(pressed, true);
  });
}

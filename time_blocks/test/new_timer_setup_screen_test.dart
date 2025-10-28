import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_blocks/screens/new_timer_setup_screen.dart';

void main() {
  testWidgets('NewTimerSetupScreen renders correctly', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: NewTimerSetupScreen()));

    // Verify that the title is displayed.
    expect(find.text('New Multi-Timer'), findsOneWidget);

    // Verify that the "Preset Name" text field is displayed.
    expect(find.widgetWithText(TextField, 'Preset Name'), findsOneWidget);

    // Verify that the "Timers" section header is displayed.
    expect(find.text('Timers'), findsOneWidget);

    // Verify that the "Add Another Timer" button is displayed.
    expect(
      find.widgetWithText(OutlinedButton, 'Add Another Timer'),
      findsOneWidget,
    );

    // Verify that the "Save Preset" button is displayed.
    expect(
      find.widgetWithText(FloatingActionButton, 'Save Preset'),
      findsOneWidget,
    );
  });

  testWidgets('Can add and remove timers', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: NewTimerSetupScreen()));

    // Verify that there is initially one timer card.
    expect(find.byType(Card), findsOneWidget);

    // Tap the "Add Another Timer" button.
    await tester.scrollUntilVisible(
      find.widgetWithText(OutlinedButton, 'Add Another Timer'),
      50,
    );
    await tester.tap(find.widgetWithText(OutlinedButton, 'Add Another Timer'));
    await tester.pumpAndSettle();

    // Verify that there are now two timer cards.
    expect(find.byType(Card), findsNWidgets(2));

    // Tap the delete button on the first timer card.
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();

    // Verify that there is now one timer card.
    expect(find.byType(Card), findsOneWidget);
  });
}

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:time_blocks/main.dart';
import 'package:time_blocks/services/timer_service.dart';

void main() {
  testWidgets('App starts and shows the dashboard screen title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => TimerService(),
        child: const MyApp(),
      ),
    );

    // Verify that the dashboard screen title is present.
    expect(find.text('Time Blocks'), findsOneWidget);
  });
}

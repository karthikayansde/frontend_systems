import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend_systems/main.dart';

void main() {
  testWidgets('Snackbar demo elements smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title is present in the app bar.
    expect(find.text('Snack Bar & Dialog Demo'), findsWidgets);

    // Verify that we can find our main action buttons.
    expect(find.text('Show Success SnackBar'), findsOneWidget);
    expect(find.text('Show Error SnackBar'), findsOneWidget);
    expect(find.text('Show Warning SnackBar with Action'), findsOneWidget);
    expect(find.text('Show Info SnackBar'), findsOneWidget);
    expect(find.text('Open Sample Dialog'), findsOneWidget);
  });

  testWidgets('Smart loading dialog shows only indicator and handles auto-dismiss', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final button = find.text('Show Smart Loading (4s Auto-Dismiss)');
    expect(button, findsOneWidget);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump(); // Start process

    // Verify only CircularProgressIndicator is present, and no message text is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Processing request...'), findsNothing);

    // Wait 4 seconds to trigger the auto-dismiss
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // Verify loading indicator is gone
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}

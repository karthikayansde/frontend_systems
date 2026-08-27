import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend_systems/main.dart';

void main() {
  testWidgets('Snackbar demo elements smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title is present in the app bar.
    expect(find.text('Snack Bar & Dialog Demo'), findsWidgets);

    // Scroll GridView to make Dialogs & Popups card visible
    final gridView = find.byType(GridView);
    await tester.drag(gridView, const Offset(0, -500));
    await tester.pumpAndSettle();

    // Navigate to DialogsScreen by tapping the card
    final dialogsCard = find.text('Dialogs & Popups');
    expect(dialogsCard, findsOneWidget);
    await tester.tap(dialogsCard);
    await tester.pumpAndSettle();

    // Verify that Open Sample Dialog is present on DialogsScreen
    expect(find.text('Open Sample Dialog'), findsOneWidget);

    // Pop back to HomePage
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Navigate to SnackBarsScreen by tapping the Snack Bars card
    final snackBarsCard = find.text('Snack Bars');
    expect(snackBarsCard, findsOneWidget);
    await tester.tap(snackBarsCard);
    await tester.pumpAndSettle();

    // Verify that we can find our main action buttons on the SnackBarsScreen.
    expect(find.text('Show Success SnackBar'), findsOneWidget);
    expect(find.text('Show Error SnackBar'), findsOneWidget);
    expect(find.text('Show Warning SnackBar with Action'), findsOneWidget);
    expect(find.text('Show Info SnackBar'), findsOneWidget);

    // Scroll down inside SingleChildScrollView to make overlay section visible
    final scrollable = find.byType(SingleChildScrollView);
    await tester.drag(scrollable, const Offset(0, -600));
    await tester.pumpAndSettle();

    // Verify overlay demo button exists and click it
    final demoButton = find.text('Open Overlay Demonstration Dialog');
    expect(demoButton, findsOneWidget);
    await tester.tap(demoButton);
    await tester.pumpAndSettle();

    // Verify dialog content and buttons
    expect(find.text('Overlay Dialog Demo'), findsOneWidget);
    expect(find.text('Normal SnackBar'), findsOneWidget);
    expect(find.text('Overlay SnackBar'), findsOneWidget);

    // Click OK to close dialog
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  });

  testWidgets('Smart loading dialog shows only indicator and handles auto-dismiss', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Scroll GridView to make Dialogs & Popups card visible
    final gridView = find.byType(GridView);
    await tester.drag(gridView, const Offset(0, -500));
    await tester.pumpAndSettle();

    // Navigate to DialogsScreen by tapping the card
    final dialogsCard = find.text('Dialogs & Popups');
    expect(dialogsCard, findsOneWidget);
    await tester.tap(dialogsCard);
    await tester.pumpAndSettle();

    final button = find.text('Show Smart Loading (4s Auto-Dismiss)');
    expect(button, findsOneWidget);
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

  testWidgets('Spacings screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Scroll GridView to make Spacings card visible
    final gridView = find.byType(GridView);
    await tester.drag(gridView, const Offset(0, -500));
    await tester.pumpAndSettle();

    // Navigate to SpacingsScreen by tapping the card
    final spacingsCard = find.text('Spacings');
    expect(spacingsCard, findsOneWidget);
    await tester.tap(spacingsCard);
    await tester.pumpAndSettle();

    // Verify page title and headers are present
    expect(find.text('Spacings & Tokens'), findsOneWidget);
    expect(find.text('Spacings'), findsWidgets); // matches header & card name
    expect(find.text('Icon Sizes'), findsOneWidget);
    expect(find.text('Border Radii'), findsOneWidget);
    expect(find.text('Elevations & Shadows'), findsOneWidget);

    // Verify that individual token names are visible
    expect(find.text('spaceXs'), findsOneWidget);
    expect(find.text('iconMedium'), findsOneWidget);
    expect(find.text('radiusLg'), findsOneWidget);
    expect(find.text('elevationHigh'), findsOneWidget);
  });

  testWidgets('Buttons screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Scroll GridView to make Buttons card visible
    final gridView = find.byType(GridView);
    await tester.drag(gridView, const Offset(0, -500));
    await tester.pumpAndSettle();

    // Navigate to ButtonsScreen by tapping the card
    final buttonsCard = find.text('Buttons');
    expect(buttonsCard, findsOneWidget);
    await tester.tap(buttonsCard);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify page title and headers are present
    expect(find.text('Buttons Explorer'), findsOneWidget);
    expect(find.text('Smart Primary Buttons (Filled)'), findsOneWidget);
    expect(find.text('Smart Primary Buttons (Outlined)'), findsOneWidget);
    expect(find.text('Smart Primary Buttons (Text)'), findsOneWidget);
    expect(find.text('Styled Icon Buttons'), findsOneWidget);
    expect(find.text('Smart Floating Action Buttons'), findsOneWidget);

    // Verify individual buttons
    expect(find.text('Primary Button'), findsOneWidget);
    expect(find.text('Disabled Button'), findsOneWidget);
    expect(find.text('Parent Loading'), findsOneWidget);
    expect(find.text('Auto Loading Button'), findsOneWidget);
    expect(find.text('Send Message'), findsOneWidget);
    expect(find.text('Delete Asset'), findsOneWidget);
    expect(find.text('Text Button'), findsOneWidget);
    expect(find.text('Disabled Text'), findsOneWidget);
    expect(find.text('Loading Text'), findsOneWidget);
    expect(find.text('Text with Icon'), findsOneWidget);
  });

  testWidgets('Form Fields screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Scroll GridView to make Form Fields card visible
    final gridView = find.byType(GridView);
    await tester.drag(gridView, const Offset(0, -900));
    await tester.pumpAndSettle();

    // Navigate to FormFieldsScreen by tapping the card
    final fieldsCard = find.text('Form Fields');
    expect(fieldsCard, findsOneWidget);
    await tester.tap(fieldsCard);
    await tester.pumpAndSettle();

    // Verify page title and headers are present
    expect(find.text('Form Fields Explorer'), findsOneWidget);
    expect(find.text('Mandatory & Required Fields'), findsOneWidget);
    expect(find.text('Optional Fields'), findsOneWidget);
    expect(find.text('Disabled & Read-Only Fields'), findsOneWidget);

    // Verify field labels
    expect(find.text('Username*'), findsOneWidget);
    expect(find.text('Read-Only API Key'), findsOneWidget);
    expect(find.text('Select Country'), findsOneWidget);
    expect(find.text('Select Country*'), findsOneWidget);
    expect(find.text('Disabled Select Country'), findsOneWidget);
    expect(find.text('Select Tech Stack'), findsOneWidget);
    expect(find.text('Select Tech Stack*'), findsOneWidget);
    expect(find.text('Disabled Select Tech Stack'), findsOneWidget);
    expect(find.text('Single Select Option'), findsOneWidget);
    expect(find.text('Disabled Single Select Option'), findsOneWidget);
    expect(find.text('Multi Select Options'), findsOneWidget);
    expect(find.text('Disabled Multi Select Options'), findsOneWidget);
    expect(find.text('Date Picker'), findsOneWidget);
    expect(find.text('Date Picker*'), findsOneWidget);
    expect(find.text('Disabled Date Picker'), findsOneWidget);
    expect(find.text('Time Picker'), findsOneWidget);
    expect(find.text('Disabled Time Picker'), findsOneWidget);
    expect(find.text('Duration Picker'), findsOneWidget);
    expect(find.text('Duration Picker*'), findsOneWidget);
    expect(find.text('Disabled Duration Picker'), findsOneWidget);
    expect(find.text('Emoji Select*'), findsOneWidget);
    expect(find.text('Color Picker*'), findsOneWidget);
  });
}

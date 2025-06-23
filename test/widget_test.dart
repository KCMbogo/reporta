// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:reporta_final/main.dart';

void main() {
  testWidgets('App starts with splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ReportaApp());

    // Verify that the splash screen is shown
    expect(find.text('Reporta'), findsOneWidget);
    expect(find.text('Inventory Management'), findsOneWidget);

    // Wait for the splash screen timer to complete
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Verify that we navigate to the login screen
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neuro_calculator/main.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NeuroCalculatorApp());

    // Verify that our app starts without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

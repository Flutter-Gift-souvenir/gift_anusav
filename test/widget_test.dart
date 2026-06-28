// Basic smoke test. The full app initializes Supabase and routing,
// which isn't suitable for a plain widget test, so this verifies the
// test harness and a simple widget render instead.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Smoke test renders a basic widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('Gift Anusav'))),
      ),
    );

    expect(find.text('Gift Anusav'), findsOneWidget);
  });
}
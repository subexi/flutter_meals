// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meals/screens/categories.dart';

// import 'package:meals/main.dart';

void main() {
  testWidgets('Categories screen renders category items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CategoriesScreen(
            onToggleFavorite: (meal) {},
          ),
        ),
      ),
    );

    expect(find.text('Italian'), findsOneWidget);
    expect(find.text('Quick & Easy'), findsOneWidget);
  });
}

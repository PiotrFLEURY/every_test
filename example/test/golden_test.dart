// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:every_test/every_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('basic golden test', (tester) async {
    await tester.pumpWidget(const MyApp(primarySwatch: Colors.blue));
    final finder = find.byType(MyApp);
    await expectLater(finder, matchesGoldenFile('goldens/blue.png'));
  });

  everyTestGolden(
    'every test golden',
    of: (tester, color) async {
      await tester.pumpWidget(MyApp(primarySwatch: color));
    },
    expects: [
      finder(find.byType(MyApp)).matches(Colors.blue, 'goldens/blue.png'),
      finder(find.byType(MyApp)).matches(Colors.red, 'goldens/red.png'),
      finder(find.byType(MyApp)).matches(Colors.green, 'goldens/green.png'),
    ],
  );
}

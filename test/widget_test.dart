import 'package:flutter_test/flutter_test.dart' show WidgetTester, expect, find, findsOneWidget, testWidgets;
import 'package:expence_tracker/main.dart';

void main() {
  testWidgets('Expense Tracker app test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text('Expense Tracker'), findsOneWidget);
  });
}

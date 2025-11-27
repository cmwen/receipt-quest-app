import 'package:flutter_test/flutter_test.dart';

import 'package:receipt_quest/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ReceiptQuestApp());
    await tester.pump();

    expect(find.byType(ReceiptQuestApp), findsOneWidget);
  });
}

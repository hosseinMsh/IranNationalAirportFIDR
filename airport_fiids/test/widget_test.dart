import 'package:flutter_test/flutter_test.dart';
import 'package:airport_fiids/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const FidsApp());
    expect(find.byType(FidsApp), findsOneWidget);
  });
}

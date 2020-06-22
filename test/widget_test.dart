import 'package:bonfire/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Checking if hello world shows up', (WidgetTester tester) async {
    await tester.pumpWidget(App());

    // Verify that our counter starts at 0.
    expect(find.text('Bonfire'), findsOneWidget);
  });
}

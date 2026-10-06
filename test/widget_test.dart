import 'package:flutter_test/flutter_test.dart';
import 'package:digital_pet/main.dart';

void main() {
  testWidgets('Digital Pet app launches', (WidgetTester tester) async {
    await tester.pumpWidget(const DigitalPetApp());

    expect(find.text('Digital Pet'), findsOneWidget);
    expect(find.text('Pip'), findsWidgets);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:campus_os/main.dart';

void main() {
  testWidgets('CampusOS app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusOSApp());

    // Verify Home screen header text exists
    expect(find.textContaining('CampusOS'), findsWidgets);
    expect(find.textContaining('Welcome Back'), findsOneWidget);
  });
}

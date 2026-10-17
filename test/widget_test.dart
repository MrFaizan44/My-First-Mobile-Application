import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:campus_os/main.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('CampusOS Part 1 smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusOSApp());

    // Verify main screen branding and tabs
    expect(find.textContaining('CampusOS'), findsWidgets);
    expect(find.textContaining('Home'), findsOneWidget);
    expect(find.textContaining('My Schedule'), findsOneWidget);
    expect(find.textContaining('Class Notes'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:study_tasker/main.dart';
import 'package:study_tasker/widgets/study_tasker_logo.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('StudyTasker smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StudyTaskerApp());

    // Verify main screen logo and bottom navigation tabs
    expect(find.byType(StudyTaskerLogo), findsWidgets);
    expect(find.textContaining('Home'), findsOneWidget);
    expect(find.textContaining('My Schedule'), findsOneWidget);
    expect(find.textContaining('Assignments'), findsOneWidget);
    expect(find.textContaining('Class Notes'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:study_tasker/main.dart';
import 'package:study_tasker/theme/app_theme.dart';
import 'package:study_tasker/widgets/study_tasker_logo.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('StudyTasker smoke test', (WidgetTester tester) async {
    final themeController = ThemeController();

    await tester.pumpWidget(
      ChangeNotifierProvider<ThemeController>.value(
        value: themeController,
        child: const StudyTaskerApp(),
      ),
    );

    // Verify main splash landing screen logo and title
    expect(find.byType(StudyTaskerLogo), findsWidgets);
    expect(find.textContaining('Opening StudyTasker...'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:break_buddy/main.dart';
import 'package:break_buddy/services/app_state_provider.dart';

void main() {
  testWidgets('Break Buddy app smoke test', (WidgetTester tester) async {
    final appStateProvider = AppStateProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<AppStateProvider>.value(
        value: appStateProvider,
        child: const BreakBuddyApp(),
      ),
    );

    // Verify Home navigation title or greeting exists
    expect(find.textContaining('Focus'), findsWidgets);
  });
}

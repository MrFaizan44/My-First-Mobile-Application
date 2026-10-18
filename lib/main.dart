import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'views/main_screen.dart';
import 'views/landing_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeController = ThemeController();
  await themeController.init();

  final prefs = await SharedPreferences.getInstance();
  final bool hasOnboarded = prefs.getBool('has_completed_onboarding') ?? false;

  runApp(
    ChangeNotifierProvider<ThemeController>.value(
      value: themeController,
      child: StudyTaskerApp(hasOnboarded: hasOnboarded),
    ),
  );
}

/// Production-grade Root Widget for StudyTasker Application
class StudyTaskerApp extends StatelessWidget {
  final bool hasOnboarded;

  const StudyTaskerApp({
    super.key,
    required this.hasOnboarded,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return MaterialApp(
          title: 'StudyTasker',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
          home: hasOnboarded ? const MainScreen() : const LandingView(),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'views/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeController = ThemeController();
  await themeController.init();

  runApp(
    ChangeNotifierProvider<ThemeController>.value(
      value: themeController,
      child: const StudyTaskerApp(),
    ),
  );
}

/// Production-grade Root Widget for StudyTasker Application
class StudyTaskerApp extends StatelessWidget {
  const StudyTaskerApp({super.key});

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
          home: const MainScreen(),
        );
      },
    );
  }
}

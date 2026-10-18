import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'views/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StudyTaskerApp());
}

/// Root Widget for StudyTasker Application
class StudyTaskerApp extends StatelessWidget {
  const StudyTaskerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyTasker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}

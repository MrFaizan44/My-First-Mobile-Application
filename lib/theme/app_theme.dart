import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Production-grade Material 3 Design System & Theme Provider for StudyTasker
class AppTheme {
  // Brand Palette
  static const Color primaryColor = Color(0xFF0F172A); // Slate 900
  static const Color brandIndigo = Color(0xFF4F46E5); // Royal Indigo
  static const Color brandCyan = Color(0xFF0288D1); // Cyan Blue
  static const Color brandPurple = Color(0xFF7C3AED); // Deep Purple
  static const Color brandRose = Color(0xFFE91E63); // Magenta Rose

  // Light Theme Tokens
  static const Color lightBackground = Color(0xFFF4F5FA);
  static const Color lightSurface = Colors.white;
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Dark Theme Tokens
  static const Color darkBackground = Color(0xFF0F1117);
  static const Color darkSurface = Color(0xFF1A1D26);
  static const Color darkBorder = Color(0xFF2D313E);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // Expanded Preset Palette of 12 Soft Pastel Course Colors
  static final List<Color> subjectColors = [
    const Color(0xFF6366F1), // Vibrant Indigo
    const Color(0xFF059669), // Emerald Green
    const Color(0xFFD97706), // Sunset Orange / Amber
    const Color(0xFFDC2626), // Coral Red
    const Color(0xFF0288D1), // Electric Cyan
    const Color(0xFF7C3AED), // Royal Purple
    const Color(0xFF0D9488), // Deep Teal
    const Color(0xFFE91E63), // Magenta Pink
    const Color(0xFF8B5CF6), // Violet
    const Color(0xFF10B981), // Mint Green
    const Color(0xFFF59E0B), // Gold
    const Color(0xFFEC4899), // Rose
  ];

  /// Material 3 Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandIndigo,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: brandIndigo,
        surface: lightSurface,
      ),
      scaffoldBackgroundColor: lightBackground,
      fontFamily: GoogleFonts.inter().fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        iconTheme: IconThemeData(color: lightTextPrimary),
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: lightBorder, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: lightSurface,
        elevation: 8,
        height: 68,
        indicatorColor: brandIndigo.withAlpha(25),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: brandIndigo,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: lightTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: brandIndigo, size: 24);
          }
          return const IconThemeData(color: lightTextSecondary, size: 22);
        }),
      ),
    );
  }

  /// Material 3 Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandIndigo,
        brightness: Brightness.dark,
        primary: brandIndigo,
        secondary: brandIndigo,
        surface: darkSurface,
      ),
      scaffoldBackgroundColor: darkBackground,
      fontFamily: GoogleFonts.inter().fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        iconTheme: IconThemeData(color: darkTextPrimary),
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        elevation: 8,
        height: 68,
        indicatorColor: brandIndigo.withAlpha(50),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: darkTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Colors.white, size: 24);
          }
          return const IconThemeData(color: darkTextSecondary, size: 22);
        }),
      ),
    );
  }
}

/// Controller managing dynamic light and dark theme mode switching
class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('is_dark_mode') ?? false;
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDark);
    notifyListeners();
  }
}

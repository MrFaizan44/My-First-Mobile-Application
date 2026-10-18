import 'package:flutter/material.dart';

/// StudyTasker Material 3 App Theme & Subject Color Options
class AppTheme {
  // Brand Palette (Cyan Blue & Deep Purple)
  static const Color primaryColor = Color(0xFF0F172A); // Slate 900
  static const Color accentColor = Color(0xFF0288D1); // Cyan Blue
  static const Color brandPurple = Color(0xFF7C3AED); // Deep Purple
  static const Color brandPink = Color(0xFFE91E63); // Magenta
  static const Color backgroundColor = Color(0xFFF8FAFC); // Clean Light Background
  static const Color surfaceColor = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  // Available Subject Color Options (Customizable by user)
  static final List<Color> subjectColors = [
    const Color(0xFF0288D1), // Cyan Blue
    const Color(0xFF7C3AED), // Deep Purple
    const Color(0xFFE91E63), // Magenta Pink
    const Color(0xFF059669), // Emerald Green
    const Color(0xFFD97706), // Amber Gold
    const Color(0xFFDC2626), // Rose Coral
    const Color(0xFF0D9488), // Teal
    const Color(0xFF4F46E5), // Indigo
  ];

  /// Material 3 Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentColor,
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Roboto',

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Card Theme with smooth elevation
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 1,
        shadowColor: const Color(0xFF0F172A).withAlpha(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Navigation Bar Theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        elevation: 8,
        height: 68,
        indicatorColor: accentColor.withAlpha(25),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: accentColor,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: accentColor, size: 24);
          }
          return const IconThemeData(color: textSecondary, size: 22);
        }),
      ),
    );
  }
}

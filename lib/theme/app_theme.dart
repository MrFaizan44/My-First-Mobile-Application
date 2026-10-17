import 'package:flutter/material.dart';

/// CampusOS App Theme & Color Palette Definitions
class AppTheme {
  // Primary Palette
  static const Color primaryColor = Color(0xFF1E293B); // Slate Dark Blue
  static const Color accentColor = Color(0xFF38BDF8); // Electric Sky Blue
  static const Color backgroundColor = Color(0xFFF8FAFC); // Clean Light Background
  static const Color surfaceColor = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  // Pastel Course & Card Accents
  static const Color pastelBlue = Color(0xFFE0F2FE);
  static const Color pastelBlueBorder = Color(0xFF38BDF8);

  static const Color pastelGreen = Color(0xFFDCFCE7);
  static const Color pastelGreenBorder = Color(0xFF22C55E);

  static const Color pastelPurple = Color(0xFFF3E8FF);
  static const Color pastelPurpleBorder = Color(0xFFA855F7);

  static const Color pastelAmber = Color(0xFFFEF3C7);
  static const Color pastelAmberBorder = Color(0xFFF59E0B);

  static const Color pastelRose = Color(0xFFFFE4E6);
  static const Color pastelRoseBorder = Color(0xFFF43F5E);

  /// Return Material 3 ThemeData for CampusOS
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
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

      // Card Theme
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Navigation Bar Theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        elevation: 10,
        height: 70,
        indicatorColor: primaryColor.withAlpha(20),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: primaryColor,
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
            return const IconThemeData(color: primaryColor, size: 24);
          }
          return const IconThemeData(color: textSecondary, size: 22);
        }),
      ),
    );
  }

  /// Soft shadow decoration for modern cards
  static BoxDecoration cardDecoration({
    Color color = surfaceColor,
    Color? borderColor,
    double borderRadius = 20.0,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      border: borderColor != null ? Border.all(color: borderColor, width: 1.2) : null,
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF0F172A).withAlpha(12),
          blurRadius: 16,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

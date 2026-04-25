import 'package:flutter/material.dart';

class AppTheme {
  // Crimson Verse Palette
  static const Color primary = Color(0xFFBA0028);
  static const Color primaryContainer = Color(0xFFFF7577);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFF6F6F6);
  static const Color surfaceContainerLow = Color(0xFFF0F1F1);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF2D2F2F);
  static const Color onSurfaceVariant = Color(0xFF5A5C5C);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.light(
      primary: primary,
      primaryContainer: primaryContainer,
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceVariant,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: onSurface),
      titleTextStyle: TextStyle(
        color: onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Manrope', color: onSurface),
      headlineMedium: TextStyle(fontFamily: 'Manrope', color: onSurface, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontFamily: 'Inter', color: onSurface),
      bodyMedium: TextStyle(fontFamily: 'Inter', color: onSurface),
      labelSmall: TextStyle(fontFamily: 'Inter', color: onSurfaceVariant),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceContainerLowest,
      selectedItemColor: primary,
      unselectedItemColor: onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}

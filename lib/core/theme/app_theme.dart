import 'package:flutter/material.dart';

class AppTheme {
  // Dark Theme Palette matching the screenshot
  static const Color background = Color(0xFF1B1D29);
  static const Color surface = Color(0xFF222433);
  static const Color surfaceContainerLow = Color(0xFF2A2D3E);
  static const Color surfaceContainerLowest = Color(0xFF1B1D29);

  static const Color primary = Color(0xFFFF4D6D);
  static const Color primaryContainer = Color(0xFFFF7577);

  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color onSurfaceVariant = Color(0xFFA0A0AA);

  // Card gradients
  static const Gradient playScriptGradient = LinearGradient(
    colors: [Color(0xFFCCFFFF), Color(0xFFE6F3FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient liveActionGradient = LinearGradient(
    colors: [Color(0xFFFFD1FF), Color(0xFFFFE6FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient tenMinScriptGradient = LinearGradient(
    colors: [Color(0xFFFFFFCC), Color(0xFFE6FFCC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
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
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: onSurface),
      headlineMedium: TextStyle(color: onSurface, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: onSurface),
      bodyMedium: TextStyle(color: onSurface),
      labelSmall: TextStyle(color: onSurfaceVariant),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: onSurface,
      unselectedItemColor: onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}

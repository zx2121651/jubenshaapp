import 'package:flutter/material.dart';

class AppTheme {
  // Dark Theme Palette matching the screenshot
  static const Color background = Color(0xFF161824); // Very dark blue/grey
  static const Color surface = Color(0xFF1F212D);
  static const Color surfaceContainerLow = Color(0xFF262836);
  static const Color surfaceContainerLowest = Color(0xFF161824);

  static const Color primary = Color(0xFFFF3366);
  static const Color primaryContainer = Color(0xFFFF7577);

  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color onSurfaceVariant = Color(0xFFA0A0AA);

  // Card gradients
  static const Gradient playScriptGradient = LinearGradient(
    colors: [Color(0xFFE0FFFF), Color(0xFFB3E5FC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient liveActionGradient = LinearGradient(
    colors: [Color(0xFFFFE4FA), Color(0xFFFFC4F0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient tenMinScriptGradient = LinearGradient(
    colors: [Color(0xFFFFFFD9), Color(0xFFE8F5C8)],
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
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: _AppPageTransitionsBuilder(),
        TargetPlatform.iOS: _AppPageTransitionsBuilder(),
        TargetPlatform.macOS: _AppPageTransitionsBuilder(),
        TargetPlatform.windows: _AppPageTransitionsBuilder(),
        TargetPlatform.linux: _AppPageTransitionsBuilder(),
      },
    ),
  );
}

/// 统一页面转场：淡入 + 轻微上移缩放，接近主流 APP 的轻量转场。
class _AppPageTransitionsBuilder extends PageTransitionsBuilder {
  const _AppPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // 次级页面：轻微缩放淡出，形成叠层感
    if (route.isFirst) return child;

    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(curved),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.98, end: 1.0).animate(curved),
          child: child,
        ),
      ),
    );
  }
}

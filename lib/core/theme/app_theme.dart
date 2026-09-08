import 'package:flutter/material.dart';

class AppTheme {
  // Dark Theme Palette matching the screenshot
  static const Color background = Color(0xFF161824); // Very dark blue/grey
  static const Color surface = Color(0xFF1F212D);
  static const Color surfaceContainerLow = Color(0xFF262836);
  static const Color surfaceContainerLowest = Color(0xFF161824);

  // 沉浸暗色体系：暗紫主色 + 暗金加分，替代高饱和玫红，贴近国内剧本杀调性
  static const Color primary = Color(0xFF8A5CF6); // 暗紫
  static const Color primaryContainer = Color(0xFFA78BFA); // 柔和紫

  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color onSurfaceVariant = Color(0xFFA0A0AA);

  // 运营卡渐变：改为暗色霓虹氛围（原马卡龙亮色过偏美式），配白字/描边
  static const Gradient playScriptGradient = LinearGradient(
    colors: [Color(0xFF3D3FA0), Color(0xFF242A5A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient liveActionGradient = LinearGradient(
    colors: [Color(0xFF5A2E52), Color(0xFF2A1830)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient tenMinScriptGradient = LinearGradient(
    colors: [Color(0xFF14414A), Color(0xFF0E2932)],
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
    // 全局滚动手感：统一为回弹（Bouncing），贴近主流剧本杀 App 的细腻滚动。
    scrollBehavior: const _AppScrollBehavior(),
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

/// 全局滚动行为：所有平台统一使用 iOS 式回弹手感，并支持透明指示条（隐藏进度条）。
class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}

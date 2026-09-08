import 'package:flutter/animation.dart';

/// 全局动效设计系统：对标主流剧本杀 APP 的过渡时长与曲线。
class AppMotion {
  AppMotion._();

  // ---- 时长 ----
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration base = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  // ---- 曲线 ----
  /// 通用缓出，进场/弹窗等。
  static const Curve easeOut = Curves.easeOutCubic;

  /// 细腻过渡（tab 切换、颜色）。
  static const Curve easeInOut = Curves.easeInOutCubic;

  /// 带轻微回弹，用于图标点击/数字跳动。
  static const Curve bounceOut = Curves.easeOutBack;

  /// 经典页面转场曲线。
  static const Curve page = Curves.fastEaseInToSlowEaseOut;
}
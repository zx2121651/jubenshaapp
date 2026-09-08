import 'package:flutter/material.dart';
import '../../../core/constants/app_motion.dart';
import '../../../shared/widgets/animations.dart';

class PlayerAvatarWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final bool isSpeaking;
  final bool isRightSide;

  const PlayerAvatarWidget({
    super.key,
    required this.name,
    required this.imageUrl,
    this.isSpeaking = false,
    this.isRightSide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Entrance(
      offset: const Offset(0, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // 说话时的呼吸脉冲光圈
              if (isSpeaking) const _SpeakingGlow(),
              // 头像：渐变底色兜底，外链图加载失败/离线时仍显示有质感头像
              AnimatedContainer(
                duration: AppMotion.slow,
                curve: AppMotion.easeOut,
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSpeaking ? Colors.amber : Colors.white54,
                    width: isSpeaking ? 3 : 2,
                  ),
                  boxShadow: isSpeaking
                      ? [
                          BoxShadow(
                            color: Colors.amber.withValues(alpha: 0.55),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                  gradient: _gradientFor(name),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // 说话指示图标
              if (isSpeaking)
                Positioned(
                  top: 0,
                  right: -12,
                  child: Bounce(
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color(0xFF161824),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.graphic_eq,
                        color: Colors.amber,
                        size: 16,
                        shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          // 玩家名
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 为玩家名生成稳定的渐变底色（与全站头像风格一致）。
LinearGradient _gradientFor(String name) {
  const palette = [
    LinearGradient(
      colors: [Color(0xFF7F5BE3), Color(0xFF43A6F6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFF6677E), Color(0xFFF6A05C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF4AC29A), Color(0xFF35B0E8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF8E54E9), Color(0xFFEF7A63)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];
  return palette[name.hashCode.abs() % palette.length];
}

/// 说话时的呼吸脉冲光圈。
class _SpeakingGlow extends StatefulWidget {
  const _SpeakingGlow();

  @override
  State<_SpeakingGlow> createState() => _SpeakingGlowState();
}

class _SpeakingGlowState extends State<_SpeakingGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return Container(
          width: 66 + 10 * t,
          height: 66 + 10 * t,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.amber.withValues(alpha: 0.8 - 0.6 * t),
              width: 3 - 1.5 * t,
            ),
          ),
        );
      },
    );
  }
}

/// 上下轻微跳动（说话图标）。
class Bounce extends StatefulWidget {
  const Bounce({super.key, required this.child});

  final Widget child;

  @override
  State<Bounce> createState() => _BounceState();
}

class _BounceState extends State<Bounce> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -3 * _controller.value),
        child: child,
      ),
      child: widget.child,
    );
  }
}
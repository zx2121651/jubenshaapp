import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_motion.dart';
import '../../../core/constants/ui_constants.dart';

class _BannerSlide {
  final String title;
  final String subtitle;
  final String cta;
  final Gradient gradient;
  final Color accent;

  const _BannerSlide({
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.gradient,
    required this.accent,
  });
}

const List<_BannerSlide> _slides = [
  _BannerSlide(
    title: '大侦探三期',
    subtitle: '完成30天任务+签到 免费获得永久装扮',
    cta: '去参加',
    gradient: LinearGradient(
      colors: [Color(0xFF3A2264), Color(0xFF241636)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    accent: Color(0xFFFFE5FF),
  ),
  _BannerSlide(
    title: '本周新本速递',
    subtitle: '高能硬核烧脑本 限时尝鲜开团',
    cta: '看详情',
    gradient: LinearGradient(
      colors: [Color(0xFF12424A), Color(0xFF14222E)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    accent: Color(0xFFB8F5FF),
  ),
  _BannerSlide(
    title: '每日签到',
    subtitle: '连续登录7天 领取钻石与限定装扮',
    cta: '去签到',
    gradient: LinearGradient(
      colors: [Color(0xFF5A2A3A), Color(0xFF301A24)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    accent: Color(0xFFFFD9A0),
  ),
];

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  final PageController _controller = PageController();
  Timer? _timer;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_controller.hasClients) return;
      final next = (_current + 1) % _slides.length;
      _controller.animateToPage(
        next,
        duration: AppMotion.base,
        curve: AppMotion.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.spacingLg),
      child: Column(
        children: [
          SizedBox(
            height: 108,
            child: PageView.builder(
              controller: _controller,
              itemCount: _slides.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (context, i) => _BannerCard(slide: _slides[i]),
            ),
          ),
          const SizedBox(height: 8),
          // 指示圆点
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_slides.length, (i) {
              return AnimatedContainer(
                duration: AppMotion.fast,
                curve: AppMotion.easeOut,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _current == i ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _current == i
                      ? const Color(0xFFB388FF)
                      : Colors.white24,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.slide});

  final _BannerSlide slide;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: slide.gradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white10, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 装饰光斑
          Positioned(
            right: -30,
            top: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    slide.accent.withValues(alpha: 0.28),
                    slide.accent.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 左侧文案
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        slide.title,
                        style: TextStyle(
                          color: slide.accent,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(color: Colors.black38, blurRadius: 8),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        slide.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: slide.accent.withValues(alpha: 0.75),
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                // 右侧 CTA
                Pressable(
                  label: slide.cta,
                  icon: Icons.arrow_forward_ios,
                  accent: slide.accent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Pressable extends StatelessWidget {
  const Pressable({
    required this.label,
    required this.icon,
    required this.accent,
  });

  final String label;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Icon(icon, color: accent, size: 14),
        ],
      ),
    );
  }
}
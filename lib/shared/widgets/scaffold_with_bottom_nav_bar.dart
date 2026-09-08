import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_motion.dart';
import '../../core/theme/app_theme.dart';

class ScaffoldWithBottomNavBar extends StatefulWidget {
  const ScaffoldWithBottomNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  StatefulNavigationShell get navigationShell => widget.navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final index = navigationShell.currentIndex;
    return Scaffold(
      // 方向感知的翻页过渡：用常驻单子树实现，避免 AnimatedSwitcher
      // 复制 StatefulNavigationShell 导致 ProviderScope 失效/状态丢失。
      body: _ShellTransition(
        index: index,
        shell: navigationShell,
        overlay: index == 0
            ? Positioned(
                bottom: 100,
                left: MediaQuery.of(context).size.width * 0.2 + 20,
                child: const _FloatingTooltip(),
              )
            : null,
      ),
      bottomNavigationBar: _AnimatedBottomBar(
        currentIndex: index,
        onDestinationSelected: _goBranch,
      ),
    );
  }
}

/// 方向感知的翻页过渡：仅在 Tab 变化时重放入场动画，
/// shell 本身始终挂载，保证各分支（含 Provider）状态稳定。
class _ShellTransition extends StatefulWidget {
  const _ShellTransition({
    required this.shell,
    required this.index,
    this.overlay,
  });

  final StatefulNavigationShell shell;
  final int index;
  final Widget? overlay;

  @override
  State<_ShellTransition> createState() => _ShellTransitionState();
}

class _ShellTransitionState extends State<_ShellTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.base,
  );

  // 记录本次切换方向：+1 向右（新页自右滑入），-1 向左。
  int _direction = 0;

  @override
  void didUpdateWidget(covariant _ShellTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != oldWidget.index) {
      _direction = widget.index > oldWidget.index ? 1 : -1;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curve = CurvedAnimation(parent: _controller, curve: AppMotion.easeOut);
    return FadeTransition(
      opacity: curve,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(_direction * 0.12, 0),
          end: Offset.zero,
        ).animate(curve),
        child: Stack(
          children: [
            widget.shell,
            if (widget.overlay != null) widget.overlay!,
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

const List<_NavItem> _navItems = [
  _NavItem(icon: Icons.theater_comedy_outlined, activeIcon: Icons.theater_comedy, label: '首页'),
  _NavItem(icon: Icons.shield_outlined, activeIcon: Icons.shield, label: '剧本'),
  _NavItem(icon: Icons.theater_comedy_outlined, activeIcon: Icons.theater_comedy, label: '互动'),
  _NavItem(icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble, label: '消息'),
  _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: '我的'),
];

class _AnimatedBottomBar extends StatelessWidget {
  const _AnimatedBottomBar({
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 76,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // 行区：左右两侧各 2 个常规 tab
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: _BarTab(
                          item: _navItems[0],
                          selected: currentIndex == 0,
                          onTap: () => onDestinationSelected(0),
                        ),
                      ),
                      Expanded(
                        child: _BarTab(
                          item: _navItems[1],
                          selected: currentIndex == 1,
                          onTap: () => onDestinationSelected(1),
                        ),
                      ),
                      // 中央占位，让两侧向左右扩散，给主按钮留出空间
                      const Spacer(flex: 2),
                      Expanded(
                        child: _BarTab(
                          item: _navItems[3],
                          selected: currentIndex == 3,
                          onTap: () => onDestinationSelected(3),
                        ),
                      ),
                      Expanded(
                        child: _BarTab(
                          item: _navItems[4],
                          selected: currentIndex == 4,
                          onTap: () => onDestinationSelected(4),
                        ),
                      ),
                    ],
                  ),
                ),
                // 中央主按钮：一键开组，纵向压住底栏
                _CentralActionButton(
                  selected: currentIndex == 2,
                  onTap: () => onDestinationSelected(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 中央「开始游戏」主按钮：国内剧本杀 App 底栏的标志性凸起元素。
class _CentralActionButton extends StatelessWidget {
  const _CentralActionButton({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 凸起圆形按钮，向上溢出底栏
          Transform.translate(
            offset: const Offset(0, -16),
            child: AnimatedContainer(
              duration: AppMotion.slow,
              curve: AppMotion.bounceOut,
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: selected
                      ? [AppTheme.primaryContainer, AppTheme.primary]
                      : [const Color(0xFF9B7BFF), const Color(0xFF6C3FDC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: selected ? 0.75 : 0.45),
                    blurRadius: selected ? 22 : 14,
                    offset: Offset(0, selected ? 8 : 5),
                  ),
                ],
              ),
              child: AnimatedScale(
                scale: selected ? 1.08 : 1.0,
                duration: AppMotion.base,
                curve: AppMotion.bounceOut,
                child: const Icon(
                  Icons.sports_esports,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            '开始游戏',
            style: TextStyle(
              color: AppTheme.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BarTab extends StatelessWidget {
  const _BarTab({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // 红点：消息常驻；首页仅未选中时提示。
    final bool showDot;
    if (item.label == '消息') {
      showDot = true;
    } else {
      showDot = item.label == '首页' && !selected;
    }

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // 激活指示器（pill）
              AnimatedContainer(
                duration: AppMotion.base,
                curve: AppMotion.easeOut,
                width: selected ? 52 : 0,
                height: 34,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              // 图标：选中时放大 + 颜色切换
              AnimatedScale(
                scale: selected ? 1.22 : 1.0,
                duration: AppMotion.base,
                curve: AppMotion.bounceOut,
                child: AnimatedSwitcher(
                  duration: AppMotion.fast,
                  child: Icon(
                    selected ? item.activeIcon : item.icon,
                    key: ValueKey<bool>(selected),
                    color: selected
                        ? AppTheme.primary
                        : AppTheme.onSurfaceVariant,
                    size: 26,
                  ),
                ),
              ),
              if (showDot)
                const Positioned(
                  top: -5,
                  right: -6,
                  child: _BadgeDot(size: 8),
                ),
            ],
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: AppMotion.base,
            curve: AppMotion.easeOut,
            style: TextStyle(
              color: selected ? AppTheme.onSurface : AppTheme.onSurfaceVariant,
              fontSize: 11,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
            child: Text(item.label),
          ),
        ],
      ),
    );
  }
}

class _BadgeDot extends StatelessWidget {
  const _BadgeDot({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppTheme.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// “剧本上新了”浮动提示，带淡入与呼吸感。
class _FloatingTooltip extends StatelessWidget {
  const _FloatingTooltip();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: AppMotion.slow,
      curve: AppMotion.bounceOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.28),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, size: 14, color: AppTheme.primary),
                SizedBox(width: 5),
                Text(
                  '剧本上新了',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -6,
            child: CustomPaint(
              size: const Size(12, 6),
              painter: _TrianglePainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
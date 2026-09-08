import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_motion.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/gradient_avatar.dart';
import '../../../shared/widgets/animations.dart';
import '../../home/data/mock_data_provider.dart';

class RoomsScreen extends ConsumerStatefulWidget {
  const RoomsScreen({super.key});

  @override
  ConsumerState<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends ConsumerState<RoomsScreen> {
  static const _chips = ['推荐', '热门', '上新', '硬核', '情感'];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final scripts = ref.watch(scriptListProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: AppTheme.primary,
          backgroundColor: AppTheme.surfaceContainerLow,
          strokeWidth: 2.4,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  UIConstants.spacingLg,
                  UIConstants.spacingLg,
                  UIConstants.spacingLg,
                  4,
                ),
                child: Row(
                  children: [
                    Icon(Icons.theater_comedy, color: AppTheme.primary, size: 24),
                    SizedBox(width: 8),
                    Text(
                      '剧本大厅',
                      style: TextStyle(
                        color: AppTheme.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 筛选 chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UIConstants.spacingLg,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: _chips.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) => _FilterChip(
                    label: _chips[i],
                    selected: _selected == i,
                    onTap: () => setState(() => _selected = i),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                UIConstants.spacingLg,
                4,
                UIConstants.spacingLg,
                100,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: UIConstants.spacingMd,
                  mainAxisSpacing: UIConstants.spacingMd,
                  // 大封面 + 底部信息，宽度:高度≈0.72（国内剧本商城的双列密度）
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final s = scripts[index];
                    return Entrance(
                      delay: Duration(milliseconds: 60 + index * 55),
                      offset: const Offset(0, 14),
                      child: _ScriptCard(script: s, index: index),
                    );
                  },
                  childCount: scripts.length,
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        curve: AppMotion.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(22),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppTheme.onSurfaceVariant,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ScriptCard extends StatelessWidget {
  const _ScriptCard({required this.script, required this.index});

  final dynamic script;
  final int index;

  @override
  Widget build(BuildContext context) {
    final s = script;
    return GestureDetector(
      onTap: () => context.push('/scripts/${s.id}'),
      child: Container(
        height: 104,
        margin: const EdgeInsets.only(bottom: UIConstants.spacingSm),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // 封面（Hero 共享元素，与详情页封面联动飞行）
            SizedBox(
              width: 72,
              child: Hero(
                tag: 'script-cover-${s.id}',
                child: GradientCover(
                  title: s.title,
                  imageUrl: s.coverUrl,
                  radius: 0,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          s.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFD4AF6A),
                        size: 16,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        _score(s),
                        style: const TextStyle(
                          color: Color(0xFFD4AF6A),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: (s.tags as List<String>).map((t) {
                      return Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          t,
                          style: const TextStyle(
                            color: AppTheme.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      GradientAvatar(text: s.authorName, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        s.authorName,
                        style: const TextStyle(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.favorite,
                        color: AppTheme.primary,
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        _format(s.likes),
                        style: const TextStyle(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.chevron_right,
                color: AppTheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _format(int n) {
    if (n >= 10000) return '${(n / 10000).toStringAsFixed(1)}万';
    return '$n';
  }

  // 稳定评分展示：由点赞数推导，落在主流评分区间 8.0~9.4。
  String _score(dynamic s) {
    return '${(8.0 + (s.likes % 15) / 10.0).toStringAsFixed(1)}';
  }
}
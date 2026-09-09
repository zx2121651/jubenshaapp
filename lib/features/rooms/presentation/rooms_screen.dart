import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_motion.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/gradient_avatar.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/loading_states.dart';
import '../../home/data/mock_data_provider.dart';
import '../../home/domain/script_model.dart';

class RoomsScreen extends ConsumerStatefulWidget {
  const RoomsScreen({super.key});

  @override
  ConsumerState<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends ConsumerState<RoomsScreen> {
  static const _sortOptions = ['综合', '人气', '评分'];
  final List<String> _categories = [];

  int _categoryIdx = 0; // 0 = 全部
  int _sortIdx = 0;
  // 筛选：人数区间 / 时长
  String _playersFilter = '不限';
  String _durationFilter = '不限';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // 初始化类型列表
    final scripts = ref.read(scriptListProvider);
    final set = <String>{};
    for (final s in scripts) {
      set.add(s.category);
    }
    _categories
      ..clear()
      ..addAll(['全部', ...set]);
    _simulateLoad();
  }

  Future<void> _simulateLoad() async {
    // 首次进入展示骨架屏
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (mounted) setState(() => _loading = false);
  }

  List<ScriptModel> _filter(List<ScriptModel> all) {
    var list = all;
    if (_categoryIdx > 0) {
      final cat = _categories[_categoryIdx];
      list = list.where((s) => s.category == cat).toList();
    }
    switch (_playersFilter) {
      case '4-5人':
        list = list.where((s) => s.players <= 5).toList();
      case '6-7人':
        list = list.where((s) => s.players >= 6 && s.players <= 7).toList();
      case '8人+':
        list = list.where((s) => s.players >= 8).toList();
    }
    switch (_durationFilter) {
      case '2小时内':
        list = list.where((s) => s.durationMins <= 120).toList();
      case '2-3小时':
        list = list.where((s) => s.durationMins > 120 && s.durationMins <= 180).toList();
      case '3小时以上':
        list = list.where((s) => s.durationMins > 180).toList();
    }
    switch (_sortIdx) {
      case 1:
        list.sort((a, b) => b.likes.compareTo(a.likes));
      case 2:
        list.sort((a, b) => b.score.compareTo(a.score));
    }
    return list;
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _openFilterSheet() async {
    final res = await showModalBottomSheet<({String players, String duration})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterSheet(
        initialPlayers: _playersFilter,
        initialDuration: _durationFilter,
      ),
    );
    if (res != null && mounted) {
      setState(() {
        _playersFilter = res.players;
        _durationFilter = res.duration;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scripts = ref.watch(scriptListProvider);
    final filtered = _filter(scripts);

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
              // 类型筛选 chips
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UIConstants.spacingLg,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, i) => _FilterChip(
                      label: _categories[i],
                      selected: _categoryIdx == i,
                      onTap: () => setState(() => _categoryIdx = i),
                    ),
                  ),
                ),
              ),
              // 排序 + 筛选行
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    UIConstants.spacingLg,
                    8,
                    UIConstants.spacingLg,
                    4,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _inlineAction(
                                label:
                                    '时间·${_durationFilter == '不限' ? '全部' : _durationFilter}'
                                        .replaceFirst('·全部', ''),
                              ),
                              const SizedBox(width: 12),
                              _inlineAction(
                                label:
                                    '人数·${_playersFilter == '不限' ? '全部' : _playersFilter}'
                                        .replaceFirst('·全部', ''),
                                onTap: _openFilterSheet,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 排序下拉
                      PopupMenuButton<int>(
                        offset: const Offset(0, 34),
                        color: AppTheme.surfaceContainerLow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        onSelected: (v) => setState(() => _sortIdx = v),
                        itemBuilder: (_) => [
                          for (var i = 0; i < _sortOptions.length; i++)
                            PopupMenuItem<int>(
                              value: i,
                              child: Row(
                                children: [
                                  if (_sortIdx == i)
                                    const Icon(
                                      Icons.check,
                                      color: AppTheme.primary,
                                      size: 16,
                                    )
                                  else
                                    const SizedBox(width: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    _sortOptions[i],
                                    style: TextStyle(
                                      color: _sortIdx == i
                                          ? AppTheme.primary
                                          : AppTheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.swap_vert,
                                  size: 14, color: AppTheme.onSurfaceVariant),
                              SizedBox(width: 3),
                              Text(
                                '排序',
                                style: TextStyle(
                                  color: AppTheme.onSurfaceVariant,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 4)),
              // 结果区：骨架屏 / 空态 / 网格
              if (_loading)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    UIConstants.spacingLg,
                    8,
                    UIConstants.spacingLg,
                    100,
                  ),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: UIConstants.spacingMd,
                      mainAxisSpacing: UIConstants.spacingMd,
                      childAspectRatio: 0.72,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const _ScriptCardSkeleton(),
                      childCount: 6,
                    ),
                  ),
                )
              else if (filtered.isEmpty)
                const SliverToBoxAdapter(
                  child: EmptyState(
                    icon: Icons.local_library_outlined,
                    title: '没有符合的本本',
                    subtitle: '换个筛选条件试试吧',
                  ),
                )
              else
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
                      childAspectRatio: 0.72,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final s = filtered[index];
                        return Entrance(
                          delay: Duration(milliseconds: 60 + index * 55),
                          offset: const Offset(0, 14),
                          child: _ScriptCard(script: s, index: index),
                        );
                      },
                      childCount: filtered.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inlineAction({required String label, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10, width: 0.5),
        ),
        child: Row(
          children: [
            const Icon(Icons.tune, size: 14, color: AppTheme.onSurfaceVariant),
            const SizedBox(width: 3),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 人数/时长筛选底部弹层。
class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initialPlayers, required this.initialDuration});

  final String initialPlayers;
  final String initialDuration;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  static const _players = ['不限', '4-5人', '6-7人', '8人+'];
  static const _durations = ['不限', '2小时内', '2-3小时', '3小时以上'];

  late String _selPlayers = widget.initialPlayers;
  late String _selDuration = widget.initialDuration;

  @override
  Widget build(BuildContext context) {
    final sheet = Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '筛选',
                style: TextStyle(
                  color: AppTheme.onSurface,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              const _FilterSectionTitle('人数'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final p in _players)
                    _ChoiceChipLabel(
                      label: p,
                      selected: _selPlayers == p,
                      onTap: () => setState(() => _selPlayers = p),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              const _FilterSectionTitle('时长'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final d in _durations)
                    _ChoiceChipLabel(
                      label: d,
                      selected: _selDuration == d,
                      onTap: () => setState(() => _selDuration = d),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selPlayers = '不限';
                          _selDuration = '不限';
                        });
                      },
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Text(
                          '重置',
                          style: TextStyle(
                            color: AppTheme.onSurfaceVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(
                        context,
                        (players: _selPlayers, duration: _selDuration),
                      ),
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9B7BFF), Color(0xFF6C3FDC)],
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Text(
                          '确定',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return sheet;
  }
}

class _FilterSectionTitle extends StatelessWidget {
  const _FilterSectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppTheme.onSurfaceVariant,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ChoiceChipLabel extends StatelessWidget {
  const _ChoiceChipLabel({
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppTheme.onSurface,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
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

/// 双列网格的骨架卡片，模拟封面+信息区占位。
class _ScriptCardSkeleton extends StatelessWidget {
  const _ScriptCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(child: SkeletonBox(height: double.infinity, radius: 0)),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonBox(width: 120, height: 14),
                SizedBox(height: 8),
                SkeletonBox(width: 70, height: 12),
                SizedBox(height: 10),
                SkeletonBox(width: 100, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScriptCard extends StatelessWidget {
  const _ScriptCard({required this.script, required this.index});

  final ScriptModel script;
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
                        s.scoreText,
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
                    children: s.tags.map((t) {
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
                      Expanded(
                        child: Text(
                          s.authorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ),
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
}
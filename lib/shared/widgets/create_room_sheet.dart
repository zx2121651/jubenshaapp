import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_motion.dart';
import '../../core/theme/app_theme.dart';
import '../../features/home/data/mock_data_provider.dart';
import '../../features/home/domain/script_model.dart';
import 'gradient_avatar.dart';

/// 打开「开局准备」底部弹层。
/// [onEnterLobby]：弹层内进入互动大厅时的回调（用于切换底部 Tab）。
void showCreateRoomSheet(BuildContext context, {VoidCallback? onEnterLobby}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) =>
        CreateRoomSheet(onEnterLobby: onEnterLobby),
  );
}

/// 沉浸式组局/拼车弹层：选剧本 → 定人数/时间 → 氛围标签 → 创建房间。
/// 对标国内主流剧本杀 App 的「一键开局」开房流程。
class CreateRoomSheet extends ConsumerStatefulWidget {
  const CreateRoomSheet({super.key, this.onEnterLobby});

  final VoidCallback? onEnterLobby;

  @override
  ConsumerState<CreateRoomSheet> createState() => _CreateRoomSheetState();
}

class _CreateRoomSheetState extends ConsumerState<CreateRoomSheet> {
  static const _moodTags = ['硬核', '欢乐', '情感', '阵营', '恐怖', '治愈'];

  ScriptModel? _selected;
  int _playerCount = 5;
  int _timeSlot = 0; // 0=今晚 1=明天 2=周末
  final Set<String> _moods = {'硬核'};

  @override
  Widget build(BuildContext context) {
    final scripts = ref.watch(scriptListProvider);
    final sheetH = MediaQuery.of(context).size.height * 0.86;

    return Container(
      height: sheetH,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // 顶部渐变头 + 拖拽指示条
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 6),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3D2A63), Color(0xFF1F212D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      SizedBox(width: 48),
                      Expanded(
                        child: Text(
                          '开局准备',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.onSurface,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: _CloseBtn(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 120),
                children: [
                  const _SectionTitle('① 选择剧本', hint: '推荐本已置顶'),
                  const SizedBox(height: 10),
                  _buildScriptPicker(scripts),
                  const SizedBox(height: 18),
                  const _SectionTitle('② 开本设置'),
                  const SizedBox(height: 8),
                  _buildOptions(),
                  const SizedBox(height: 18),
                  const _SectionTitle('③ 氛围标签', hint: '最多选 3 个'),
                  const SizedBox(height: 8),
                  _buildMoodChips(),
                  if (widget.onEnterLobby != null) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: widget.onEnterLobby,
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryContainer,
                        ),
                        icon: const Icon(Icons.forum, size: 18),
                        label: const Text('先去互动大厅逛逛'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // 底部 CTA
            _buildBottomCta(),
          ],
        ),
      ),
    );
  }

  Widget _buildScriptPicker(List<ScriptModel> scripts) {
    return SizedBox(
      height: 148,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: scripts.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final s = scripts[i];
          final sel = _selected?.id == s.id;
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _selected = s;
                _playerCount = s.players.clamp(3, 8);
              });
            },
            child: AnimatedContainer(
              duration: AppMotion.fast,
              width: 104,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: sel ? AppTheme.primary : Colors.transparent,
                  width: 2,
                ),
                boxShadow: sel
                    ? [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GradientCover(title: s.title, imageUrl: s.coverUrl, radius: 0),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${s.players}人 · ${s.durationMins ~/ 60}h',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (sel)
                    const Positioned(
                      top: 6,
                      right: 6,
                      child: _SelectedBadge(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            _optionRow(
              label: '人数',
              value: '$_playerCount 人',
              onMinus: () => setState(() {
                _playerCount = (_playerCount - 1).clamp(3, 8);
              }),
              onPlus: () => setState(() {
                _playerCount = (_playerCount + 1).clamp(3, 8);
              }),
              custom: const Icon(Icons.group, size: 18, color: AppTheme.primary),
            ),
            const Divider(color: Colors.white10, height: 20),
            _optionRow(
              label: '开局时间',
              value: const ['今晚', '明天', '周末'][_timeSlot],
              onMinus: null,
              onPlus: null,
              custom: Row(
                children: [
                  for (var i = 0; i < 3; i++)
                    GestureDetector(
                      onTap: () => setState(() => _timeSlot = i),
                      child: AnimatedContainer(
                        duration: AppMotion.fast,
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _timeSlot == i
                              ? AppTheme.primary
                              : AppTheme.surface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          const ['今晚', '明天', '周末'][i],
                          style: TextStyle(
                            color: _timeSlot == i
                                ? Colors.white
                                : AppTheme.onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionRow({
    required String label,
    required String value,
    required VoidCallback? onMinus,
    required VoidCallback? onPlus,
    required Widget custom,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.onSurfaceVariant,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: Align(alignment: Alignment.centerRight, child: custom)),
      ],
    );
  }

  Widget _buildMoodChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final m in _moodTags)
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  if (_moods.contains(m)) {
                    _moods.remove(m);
                  } else if (_moods.length < 3) {
                    _moods.add(m);
                  }
                });
              },
              child: AnimatedContainer(
                duration: AppMotion.fast,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _moods.contains(m)
                      ? AppTheme.primary
                      : AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  m,
                  style: TextStyle(
                    color: _moods.contains(m)
                        ? Colors.white
                        : AppTheme.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomCta() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () {
            if (_selected == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('先选一个想开的剧本吧'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppTheme.surfaceContainerLow,
                ),
              );
              return;
            }
            context.go('/room/${_selected!.id}');
          },
          child: AnimatedContainer(
            duration: AppMotion.base,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _selected == null
                    ? [const Color(0xFF3A3B52), const Color(0xFF30314A)]
                    : [const Color(0xFF9B7BFF), const Color(0xFF6C3FDC)],
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: _selected == null
                  ? null
                  : [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.45),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: Text(
              _selected == null ? '请先选择剧本' : '创建房间 · ${_selected!.title}',
              style: TextStyle(
                color: _selected == null ? Colors.white38 : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, {this.hint});
  final String text;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              color: AppTheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (hint != null) ...[
            const SizedBox(width: 6),
            Text(
              hint!,
              style: const TextStyle(
                color: AppTheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CloseBtn extends StatelessWidget {
  const _CloseBtn();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: Colors.white10,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, size: 18, color: AppTheme.onSurfaceVariant),
      ),
    );
  }
}

class _SelectedBadge extends StatelessWidget {
  const _SelectedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: AppTheme.primary,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, size: 14, color: Colors.white),
    );
  }
}
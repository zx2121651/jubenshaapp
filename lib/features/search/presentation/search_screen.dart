import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/gradient_avatar.dart';
import '../../../shared/widgets/loading_states.dart';
import '../../home/data/mock_data_provider.dart';
import '../../home/domain/script_model.dart';

/// 全局搜索页：热门搜索 + 搜索历史 + 实时结果。
/// 支持按标题 / 类型 / 标签检索，复用于首页搜索入口。
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  static const _hotKeyword = ['恐怖', '硬核', '情感', '阵营', '古风', '海龟汤'];

  final TextEditingController _controller = TextEditingController();
  final List<String> _history = [];

  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    setState(() => _query = v.trim());
  }

  void _submit(String kw) {
    if (kw.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() {
      _query = kw;
      _controller.text = kw;
      _controller.selection = TextSelection.collapsed(offset: kw.length);
      _history
        ..remove(kw)
        ..insert(0, kw);
    });
  }

  void _clearHistory() => setState(_history.clear);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.onSurface),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: TextField(
            controller: _controller,
            autofocus: true,
            onChanged: _onChanged,
            onSubmitted: _submit,
            textInputAction: TextInputAction.search,
            style: const TextStyle(color: AppTheme.onSurface),
            cursorColor: AppTheme.primary,
            decoration: InputDecoration(
              icon: const Icon(Icons.search,
                  color: AppTheme.onSurfaceVariant, size: 18),
              hintText: '搜索剧本 / 作者 / 标签',
              hintStyle: const TextStyle(
                color: AppTheme.onSurfaceVariant,
                fontSize: 13,
              ),
              suffixIcon: _query.isEmpty
                  ? null
                  : GestureDetector(
                      onTap: () {
                        _controller.clear();
                        _onChanged('');
                      },
                      child: const Icon(Icons.cancel,
                          color: AppTheme.onSurfaceVariant, size: 16),
                    ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 11),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: TextButton(
              onPressed: () {
                if (_query.isNotEmpty) {
                  _submit(_query);
                } else {
                  context.pop();
                }
              },
              child: const Text(
                '搜索',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _query.isEmpty ? _buildSuggest() : _buildResults(),
    );
  }

  // ---- 无输入：热门搜索 + 历史 ----
  Widget _buildSuggest() {
    return ListView(
      padding: const EdgeInsets.all(UIConstants.spacingLg),
      children: [
        const Text(
          '热门搜索',
          style: TextStyle(
            color: AppTheme.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final kw in _hotKeyword)
              GestureDetector(
                onTap: () => _submit(kw),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    kw,
                    style: const TextStyle(
                      color: AppTheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (_history.isNotEmpty) ...[
          const SizedBox(height: 28),
          Row(
            children: [
              const Text(
                '搜索历史',
                style: TextStyle(
                  color: AppTheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: _clearHistory,
                child: const Icon(Icons.delete_outline,
                    color: AppTheme.onSurfaceVariant, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final kw in _history)
                GestureDetector(
                  onTap: () => _submit(kw),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white12),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      kw,
                      style: const TextStyle(
                        color: AppTheme.onSurface,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  // ---- 有输入：实时结果 ----
  Widget _buildResults() {
    final scripts = ref.watch(scriptListProvider);
    final kw = _query.toLowerCase();
    final results = scripts.where((s) {
      return s.title.toLowerCase().contains(kw) ||
          s.category.toLowerCase().contains(kw) ||
          s.tags.any((t) => t.toLowerCase().contains(kw));
    }).toList();

    if (results.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off,
        title: '没有找到相关剧本',
        subtitle: '换个关键词试试吧',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        UIConstants.spacingLg,
        UIConstants.spacingSm,
        UIConstants.spacingLg,
        40,
      ),
      itemCount: results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final s = results[i];
        return Entrance(
          delay: Duration(milliseconds: 60 + i * 45),
          offset: const Offset(0, 12),
          child: _SearchResultTile(script: s),
        );
      },
    );
  }
}

/// 单条搜索结果卡。
class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.script});

  final ScriptModel script;

  @override
  Widget build(BuildContext context) {
    final s = script;
    return GestureDetector(
      onTap: () {
        context.push('/scripts/${s.id}');
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10, width: 0.6),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 66,
              height: 66,
              child: GradientCover(
                title: s.title,
                imageUrl: s.coverUrl,
                radius: 10,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        '${s.players}人 · ${s.durationMins ~/ 60}h',
                        style: const TextStyle(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 10,
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
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          t,
                          style: const TextStyle(
                            color: AppTheme.primaryContainer,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(Icons.person_outline,
                          color: AppTheme.onSurfaceVariant, size: 12),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          s.authorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const Icon(Icons.favorite, color: AppTheme.primary, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        '${s.likes}',
                        style: const TextStyle(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right,
                color: AppTheme.onSurfaceVariant, size: 18),
          ],
        ),
      ),
    );
  }
}
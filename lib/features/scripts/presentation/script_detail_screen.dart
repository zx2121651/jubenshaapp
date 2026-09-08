import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/gradient_avatar.dart';
import '../../../shared/widgets/animations.dart';
import '../../home/data/mock_data_provider.dart';
import '../../home/domain/script_model.dart';

class ScriptDetailScreen extends ConsumerWidget {
  const ScriptDetailScreen({super.key, required this.scriptId});

  final String scriptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scripts = ref.watch(scriptListProvider);
    final script =
        scripts.firstWhere((s) => s.id == scriptId, orElse: () => scripts.first);
    final others =
        scripts.where((s) => s.id != script.id).take(4).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 封面头部
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  SizedBox(
                    height: 320,
                    child: Hero(
                      tag: 'script-cover-${script.id}',
                      child: GradientCover(
                        title: script.title,
                        imageUrl: script.coverUrl,
                        radius: 0,
                        icon: Icons.theater_comedy,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 8,
                    child: _RoundIconButton(
                      icon: Icons.arrow_back,
                      onTap: () => context.pop(),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 8,
                    child: _RoundIconButton(icon: Icons.share_outlined),
                  ),
                  // 底部渐隐
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 80,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppTheme.background.withValues(alpha: 0),
                            AppTheme.background,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.spacingLg,
                ),
                child: Entrance(
                  offset: const Offset(0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              script.title,
                              style: const TextStyle(
                                color: AppTheme.onSurface,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          _Price(script: script),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: (script.tags).map((t) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Text(
                              t,
                              style: const TextStyle(
                                color: AppTheme.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          GradientAvatar(text: script.authorName, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            script.authorName,
                            style: const TextStyle(
                              color: AppTheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.favorite,
                            color: AppTheme.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${script.likes}',
                            style: const TextStyle(
                              color: AppTheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            // 简介
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.spacingLg,
                ),
                child: Entrance(
                  delay: const Duration(milliseconds: 80),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '剧本简介',
                          style: TextStyle(
                            color: AppTheme.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '一封神秘邀请函，将一群素不相识的人聚集于此。迷雾笼罩的庄园里，真相被层层包裹。 '
                          '你是见证者，也是局中人。拨开浮云，找出隐藏在你我之间的秘密。（示例简介文案）',
                          style: TextStyle(
                            color: AppTheme.onSurfaceVariant,
                            fontSize: 12,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            // 角色简介（主流详情页标配：带插图的角色卡）
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.spacingLg,
                ),
                child: Entrance(
                  delay: const Duration(milliseconds: 100),
                  offset: const Offset(0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '角色简介',
                        style: TextStyle(
                          color: AppTheme.onSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const _RoleCard(),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            // 口碑评分（主流详情页标配：维度得分 + 用户评价）
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.spacingLg,
                ),
                child: Entrance(
                  delay: const Duration(milliseconds: 120),
                  offset: const Offset(0, 16),
                  child: _ReputationSection(script: script),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            // 相关剧本
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: UIConstants.spacingLg),
                child: Text(
                  '更多精彩剧本',
                  style: TextStyle(
                    color: AppTheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.spacingLg,
              ),
              sliver: SliverList.builder(
                itemCount: others.length,
                itemBuilder: (context, index) => Entrance(
                  delay: Duration(milliseconds: 120 + index * 55),
                  child: _RelatedScriptTile(script: others[index]),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border(
            top: BorderSide(color: Colors.white10, width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: GestureDetector(
            onTap: () => context.push('/room/123'),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8A5CF6), Color(0xFFB488FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8A5CF6).withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                '立即发车',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 口碑评分区：多维度得分 + 用户评价，国内剧本 App 详情页的核心信任模块。
class _ReputationSection extends StatelessWidget {
  const _ReputationSection({required this.script});

  final ScriptModel script;

  // 基于剧本 id 生成稳定的维度分（8~9.8 区间），避免每次刷新跳动。
  List<double> _dims() {
    final seed = script.id.hashCode.abs() % 100;
    return [
      8.4 + (seed % 14) / 10,
      8.0 + ((seed * 3) % 16) / 10,
      8.6 + ((seed * 7) % 12) / 10,
      8.2 + ((seed * 5) % 14) / 10,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final dims = _dims();
    final avg = (dims.reduce((a, b) => a + b) / dims.length).toStringAsFixed(1);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '口碑评价',
            style: TextStyle(
              color: AppTheme.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // 综合评分大数字
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primaryContainer],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        avg,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        '综合评分',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  children: [
                    _dimRow('沉浸氛围', dims[0]),
                    const SizedBox(height: 8),
                    _dimRow('烧脑指数', dims[1]),
                    const SizedBox(height: 8),
                    _dimRow('情感代入', dims[2]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 14),
          const _ReviewTile(
            user: '雾里看花',
            text: '剧情反转绝绝子，DM 带得很投入，环境氛围拉满，硬核玩家闭眼入。',
            tag: '硬核爱好者',
          ),
          const SizedBox(height: 10),
          const _ReviewTile(
            user: '夜半话鬼',
            text: '情感线很戳人，玩到最后眼眶都红了，适合熟人车。',
            tag: '情感玩家',
          ),
        ],
      ),
    );
  }

  Widget _dimRow(String label, double score) {
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: (score - 8) / 2,
              minHeight: 5,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 26,
          child: Text(
            score.toStringAsFixed(1),
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFFD4AF6A),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({
    required this.user,
    required this.text,
    required this.tag,
  });

  final String user;
  final String text;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientAvatar(text: user, size: 30),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    user,
                    style: const TextStyle(
                      color: AppTheme.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                text,
                style: const TextStyle(
                  color: AppTheme.onSurfaceVariant,
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 角色简介卡：主流详情页标配，渐变头像 + 姓名/性格标签 + 一行简介。
class _RoleCard extends StatelessWidget {
  const _RoleCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          const GradientAvatar(text: '林', size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '林晚秋',
                      style: TextStyle(
                        color: AppTheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '冷静沉着',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  '出身名门的记者，看似柔弱却心思缜密，对庄园的每一封请柬都抱有几分疑虑。',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppTheme.onSurfaceVariant,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white30, size: 18),
        ],
      ),
    );
  }
}

class _Price extends StatelessWidget {
  const _Price({required this.script});

  final ScriptModel script;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${30 + script.id.hashCode.abs() % 50}',
          style: const TextStyle(
            color: Color(0xFFD4AF6A),
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Text(
          ' 金币/人',
          style: TextStyle(fontSize: 11, color: Colors.white54),
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _RelatedScriptTile extends StatelessWidget {
  const _RelatedScriptTile({required this.script});

  final ScriptModel script;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/scripts/${script.id}'),
      child: Container(
        height: 64,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 46,
              child: Hero(
                tag: 'script-cover-${script.id}',
                child: GradientCover(
                  title: script.title,
                  imageUrl: script.coverUrl,
                  radius: 8,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    script.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.onSurface,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    script.tags.join(' / '),
                    style: const TextStyle(
                      color: AppTheme.onSurfaceVariant,
                      fontSize: 11,
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
}
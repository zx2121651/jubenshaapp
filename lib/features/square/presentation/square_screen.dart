import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_motion.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/gradient_avatar.dart';
import '../../../shared/widgets/animations.dart';

class SquareScreen extends StatefulWidget {
  const SquareScreen({super.key});

  @override
  State<SquareScreen> createState() => _SquareScreenState();
}

class _SquareScreenState extends State<SquareScreen> {
  static const _chips = ['全部', '找队友', '晒体验', '求本', '灌水'];
  int _selected = 0;

  static const _posts = [
    {
      'user': '最低价要的来啊',
      'time': '10分钟前',
      'content': '今晚八点开一车高分硬核本，还差两个人，来报名的评论区扣1～',
      'likes': 126,
      'comments': 34,
    },
    {
      'user': '塔 不限 DD一下',
      'time': '30分钟前',
      'content': '主页互赞互赞互赞，点头像有惊喜，日常求本求组队。',
      'likes': 89,
      'comments': 12,
    },
    {
      'user': '全服告白',
      'time': '1小时前',
      'content': '记得坦诚 全服告白，不爱记得坦诚，你是我见过最温柔的侦探。',
      'likes': 568,
      'comments': 210,
    },
    {
      'user': '张林路',
      'time': '2小时前',
      'content': '刚打完《长安夜行》，阵营本天花板！强烈安利，DM节奏带得超好。',
      'likes': 320,
      'comments': 78,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                    Icon(Icons.explore, color: AppTheme.primary, size: 24),
                    SizedBox(width: 8),
                    Text(
                      '剧本广场',
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
            // 正在语音 / 开黑中的房间（互动增强）
            const SliverToBoxAdapter(child: _VoiceRoomSection()),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UIConstants.spacingLg,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: _chips.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) => _Chip(
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
              sliver: SliverList.builder(
                itemCount: _posts.length,
                itemBuilder: (context, index) => Entrance(
                  delay: Duration(milliseconds: 60 + index * 55),
                  offset: const Offset(0, 14),
                  child: _PostCard(post: _posts[index].cast()),
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

class _Chip extends StatelessWidget {
  const _Chip({
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

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: UIConstants.spacingMd),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GradientAvatar(text: post['user'] as String, size: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['user'] as String,
                      style: const TextStyle(
                        color: AppTheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      post['time'] as String,
                      style: const TextStyle(
                        color: AppTheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, color: Colors.white38),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            post['content'] as String,
            style: TextStyle(
              color: AppTheme.onSurface.withValues(alpha: 0.9),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _action(Icons.favorite_border, '${post['likes']}', AppTheme.primary),
              const SizedBox(width: 20),
              _action(Icons.chat_bubble_outline, '${post['comments']}', Colors.white54),
            ],
          ),
        ],
      ),
    );
  }

  Widget _action(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 12),
        ),
      ],
    );
  }
}

/// 「正在语音 · 开黑中」区：横向语音房间列表，带互动氛围动效。
class _VoiceRoomSection extends StatelessWidget {
  const _VoiceRoomSection();

  static const _rooms = [
    {
      'title': '晚安硬核开黑',
      'count': '6人 进行中',
      'tags': ['硬核', '海龟汤'],
      'names': ['晓', '阿澈', '老白'],
    },
    {
      'title': '欢乐互怼屋',
      'count': '4人 进行中',
      'tags': ['欢乐', '闲聊'],
      'names': ['桃桃', '阿豪'],
    },
    {
      'title': '推理之夜',
      'count': '8人 等待中',
      'tags': ['还原', '新本'],
      'names': ['十方', 'Niko'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            UIConstants.spacingLg,
            UIConstants.spacingMd,
            UIConstants.spacingLg,
            8,
          ),
          child: const Row(
            children: [
              _LivePulse(),
              SizedBox(width: 6),
              Text(
                '正在语音',
                style: TextStyle(
                  color: AppTheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '开黑中，点进去一起玩',
                  style: TextStyle(
                    color: AppTheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.chevron_right, size: 18, color: Colors.white38),
            ],
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.spacingLg,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: _rooms.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final r = _rooms[i];
              return GestureDetector(
                onTap: () => context.push('/room/voice$i'),
                child: Container(
                  width: 168,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10, width: 0.6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // 头像堆叠
                          SizedBox(
                            height: 26,
                            child: Stack(
                              children: [
                                for (var j = 0; j < (r['names'] as List).length; j++)
                                  Positioned(
                                    left: j * 16,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppTheme.surfaceContainerLow,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: GradientAvatar(
                                        text: (r['names'] as List)[j] as String,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          _VoiceWaveBar(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        r['title'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.onSurface,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            (r['count'] as String).contains('等待') 
                                ? Icons.schedule
                                : Icons.graphic_eq,
                            size: 12,
                            color: (r['count'] as String).contains('等待')
                                ? Colors.white38
                                : AppTheme.primaryContainer,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            r['count'] as String,
                            style: TextStyle(
                              color: (r['count'] as String).contains('等待')
                                  ? Colors.white38
                                  : AppTheme.primaryContainer,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: (r['tags'] as List).map((t) {
                          return Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              t as String,
                              style: const TextStyle(
                                color: AppTheme.primaryContainer,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

/// 绿色「直播中」圆点脉冲。
class _LivePulse extends StatefulWidget {
  const _LivePulse();

  @override
  State<_LivePulse> createState() => _LivePulseState();
}

class _LivePulseState extends State<_LivePulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.primaryContainer,
        ),
        child: Center(
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF34C77B),
            ),
          ),
        ),
      ),
    );
  }
}

/// 语音波形条（静态渐变条，表达说话中的氛围）。
class _VoiceWaveBar extends StatelessWidget {
  const _VoiceWaveBar();

  static const _heights = [4.0, 10.0, 6.0, 13.0, 8.0, 5.0, 11.0];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final h in _heights)
          Container(
            width: 3,
            height: h,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        const SizedBox(width: 2),
        Text(
          'LIVE',
          style: TextStyle(
            color: AppTheme.primaryContainer.withValues(alpha: 0.9),
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
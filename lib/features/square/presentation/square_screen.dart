import 'package:flutter/material.dart';
import '../../core/constants/app_motion.dart';
import '../../core/constants/ui_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/gradient_avatar.dart';

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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
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
    );
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
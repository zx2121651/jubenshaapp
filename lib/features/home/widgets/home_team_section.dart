import 'package:flutter/material.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/animations.dart';
import '../../../shared/widgets/gradient_avatar.dart';

/// 首页「正在组局」：国内剧本杀 App 首页的标志性布局，
/// 实时展示进行中的组局/车队（剧本、房主、坑位、倒计时），制造临场紧迫感与一键加入入口。
class HomeTeamSection extends StatelessWidget {
  const HomeTeamSection({super.key});

  static const List<_Team> _teams = [
    _Team(
      script: '阴阳诡案',
      style: '悬疑 / 硬核 · 6 人本',
      host: '林·侦探',
      slotsLeft: 2,
      players: 4,
      eta: '13 分钟后开始',
      gradient: [Color(0xFF3A3D66), Color(0xFF20233F)],
      filling: true,
    ),
    _Team(
      script: '山海镜花',
      style: '情感 / 还原 · 4 人本',
      host: '云上客',
      slotsLeft: 3,
      players: 1,
      eta: '今晚 · 20:00',
      gradient: [Color(0xFF56407A), Color(0xFF2B2140)],
      filling: false,
    ),
    _Team(
      script: '午夜鉴宝',
      style: '机制 / 阵营 · 8 人本',
      host: '老猫',
      slotsLeft: 1,
      players: 7,
      eta: '5 分钟后开始',
      gradient: [Color(0xFF3B5A4E), Color(0xFF16231F)],
      filling: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: UIConstants.spacingMd),
        SizedBox(
          height: 128,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.spacingLg,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: _teams.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, i) =>
                Entrance(delay: Duration(milliseconds: 60 + i * 60), child: _TeamCard(team: _teams[i])),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.spacingLg),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            '正在组局',
            style: TextStyle(
              color: AppTheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            '发现你的队',
            style: TextStyle(
              color: AppTheme.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: const Row(
              children: [
                Text(
                  '去组一局',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Icon(Icons.chevron_right, color: AppTheme.primary, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard({required this.team});

  final _Team team;

  @override
  Widget build(BuildContext context) {
    // 卡片宽度一致，横向等宽：封面 + 信息。
    return Container(
      width: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: team.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // 剧本封面占位
            Container(
              width: 54,
              height: 84,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white12),
              ),
              child: const Icon(
                Icons.auto_stories,
                color: Colors.white38,
                size: 28,
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
                          team.script,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (team.filling)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0647C),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '冲刺',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    team.style,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      GradientAvatar(text: team.host, size: 18),
                      const Spacer(),
                      Text(
                        '${team.players}/${team.players + team.slotsLeft} 人',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '+${team.slotsLeft}',
                        style: TextStyle(
                          color: const Color(0xFFE6B866),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.alarm,
                        color: Colors.white.withValues(alpha: 0.6),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          team.eta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '加入',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
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

class _Team {
  final String script;
  final String style;
  final String host;
  final int players;
  final int slotsLeft;
  final String eta;
  final List<Color> gradient;
  final bool filling;

  const _Team({
    required this.script,
    required this.style,
    required this.host,
    required this.players,
    required this.slotsLeft,
    required this.eta,
    required this.gradient,
    required this.filling,
  });
}
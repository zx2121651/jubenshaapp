import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 礼物面板：选择礼物、指定赠送对象，赠送后回调返回结果。
class GiftPanelSheet extends StatefulWidget {
  const GiftPanelSheet({super.key});

  @override
  State<GiftPanelSheet> createState() => _GiftPanelSheetState();
}

class _GiftPanelSheetState extends State<GiftPanelSheet> {
  static const List<String> _players = [
    '张林路', '爱丽丝', '李子明', '鹿鸣', '胡云闪',
    '陈侦探', '孙允珠', '李子航', '吴晓波', '王华丽',
  ];

  static const List<({String name, int cost, IconData icon})> _gifts = [
    (name: '玫瑰', cost: 10, icon: Icons.local_florist),
    (name: '小心心', cost: 20, icon: Icons.favorite),
    (name: '蛋糕', cost: 30, icon: Icons.cake_outlined),
    (name: '香槟', cost: 50, icon: Icons.local_bar),
    (name: '火箭', cost: 520, icon: Icons.rocket_launch),
    (name: '皇冠', cost: 888, icon: Icons.emoji_events),
  ];

  String? _gift;
  String? _toPlayer;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.68,
      decoration: const BoxDecoration(
        color: Color(0xFF161824),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // 顶部把手
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 标题 + 余额
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  const Icon(
                    Icons.card_giftcard,
                    color: Color(0xFFE0647C),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '礼物会场',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB74D).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.stars,
                          color: Color(0xFFFFB74D),
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '余额 2600',
                          style: TextStyle(
                            color: Color(0xFFFFB74D),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // 礼物网格
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.1,
                ),
                itemCount: _gifts.length,
                itemBuilder: (context, i) {
                  final g = _gifts[i];
                  final sel = _gift == g.name;
                  return GestureDetector(
                    key: ValueKey('gift-${g.name}'),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _gift = g.name);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      decoration: BoxDecoration(
                        color: sel
                            ? const Color(0xFFE0647C).withValues(alpha: 0.18)
                            : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: sel
                              ? const Color(0xFFE0647C)
                              : Colors.white12,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            g.icon,
                            color: sel
                                ? const Color(0xFFE0647C)
                                : Colors.white70,
                            size: 30,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            g.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${g.cost} 币',
                            style: TextStyle(
                              color: sel
                                  ? const Color(0xFFE0647C)
                                  : const Color(0xFFFFB74D),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // 赠送给 + 大按钮
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 16),
              child: Column(
                children: [
                  // 收礼人横向滚动
                  SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _players.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final name = _players[i];
                        final sel = _toPlayer == name;
                        return GestureDetector(
                          key: ValueKey('to-$name'),
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _toPlayer = name);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: sel
                                  ? const Color(0xFFAC5AF0).withValues(
                                      alpha: 0.25,
                                    )
                                  : Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: sel
                                    ? const Color(0xFFAC5AF0)
                                    : Colors.white12,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: sel
                                      ? const Color(0xFFAC5AF0)
                                      : Colors.white.withValues(alpha: 0.1),
                                  child: Text(
                                    name.characters.first,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 赠送按钮
                  GestureDetector(
                    onTap: () {
                      if (_gift != null && _toPlayer != null) {
                        HapticFeedback.mediumImpact();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '已向 $_toPlayer 送出「$_gift」',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            backgroundColor: const Color(0xFFE0647C),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 48,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: const [
                            Color(0xFFE0647C),
                            Color(0xFFC94B6A),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        color: (_gift != null && _toPlayer != null)
                            ? null
                            : Colors.white12,
                        boxShadow: (_gift != null && _toPlayer != null)
                            ? [
                                BoxShadow(
                                  color: const Color(0xFFE0647C).withValues(
                                    alpha: 0.4,
                                  ),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _gift == null && _toPlayer == null
                            ? '请选择礼物与赠送对象'
                            : _gift == null
                                ? '请选择礼物'
                                : _toPlayer == null
                                    ? '请选择对象'
                                    : '送出 $_gift 给 $_toPlayer',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
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
}
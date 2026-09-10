import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/game_room_header.dart';
import '../widgets/player_avatar_widget.dart';
import '../widgets/game_chat_overlay.dart';
import '../widgets/game_bottom_bar.dart';
import '../widgets/script_reader_sheet.dart';

/// 游戏阶段定义。
class GameStage {
  const GameStage(this.label, this.color);

  final String label;
  final Color color;
}

const List<GameStage> _stages = [
  GameStage('剧本阅读阶段', Color(0xFFFFB74D)),
  GameStage('搜证阶段', Color(0xFF4DD0E1)),
  GameStage('讨论阶段', Color(0xFFB388FF)),
  GameStage('投票阶段', Color(0xFFFF8A80)),
  GameStage('揭晓时刻', Color(0xFF69F0AE)),
];

const List<String> _playerNames = [
  '张林路', '爱丽丝', '李子明', '鹿鸣', '胡云闪',
  '陈侦探', '孙允珠', '李子航', '吴晓波', '王华丽',
];

class GameRoomScreen extends StatefulWidget {
  final String roomId;
  const GameRoomScreen({super.key, required this.roomId});

  @override
  State<GameRoomScreen> createState() => _GameRoomScreenState();
}

class _GameRoomScreenState extends State<GameRoomScreen> {
  int _stage = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _advanceStage() {
    setState(() => _stage = (_stage + 1) % _stages.length);
  }

  void _showClueBoard() {
    HapticFeedback.selectionClick();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _ClueBoardSheet(),
    );
  }

  void _showScriptSheet() {
    HapticFeedback.selectionClick();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const ScriptReaderSheet(),
    );
  }

  Future<void> _showVoteSheet() async {
    HapticFeedback.selectionClick();
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _VoteSheet(),
    );
    if (picked == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('你已投票给 $picked，结果将在揭晓阶段公布。'),
        backgroundColor: const Color(0xFF2A2C3A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stage = _stages[_stage];
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 背景地图（渐变底纹兜底）
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) =>
                Opacity(opacity: value, child: child),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2B2340), Color(0xFF0E1017)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?q=80&w=1200&auto=format&fit=crop',
                  ),
                  fit: BoxFit.cover,
                  onError: (_, _) {},
                  colorFilter: ColorFilter.mode(
                    Colors.black38,
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),

          // 左侧玩家
          const Positioned(top: 150, left: 20,
              child: _Avatar(name: '张林路', url: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&auto=format&fit=crop&q=60')),
          Positioned(
              top: 240, left: 20,
              child: _Avatar(name: '爱丽丝',
                  url: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&auto=format&fit=crop&q=60',
                  speaking: true)),
          const Positioned(top: 330, left: 20,
              child: _Avatar(name: '李子明', url: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=100&auto=format&fit=crop&q=60')),
          const Positioned(top: 420, left: 20,
              child: _Avatar(name: '鹿鸣', url: 'https://images.unsplash.com/photo-1521119989659-a83eee488004?w=100&auto=format&fit=crop&q=60')),
          const Positioned(top: 510, left: 20,
              child: _Avatar(name: '胡云闪', url: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=60')),

          // 右侧玩家
          const Positioned(top: 150, right: 20,
              child: _Avatar(name: '陈侦探', url: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=100&auto=format&fit=crop&q=60', right: true)),
          const Positioned(top: 240, right: 20,
              child: _Avatar(name: '孙允珠', url: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&auto=format&fit=crop&q=60', right: true)),
          const Positioned(top: 330, right: 20,
              child: _Avatar(name: '李子航', url: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&auto=format&fit=crop&q=60', right: true)),
          const Positioned(top: 420, right: 20,
              child: _Avatar(name: '吴晓波', url: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&auto=format&fit=crop&q=60', right: true)),
          const Positioned(top: 510, right: 20,
              child: _Avatar(name: '王华丽', url: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&auto=format&fit=crop&q=60', right: true)),

          // 顶部头部（阶段交互）
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GameRoomHeader(
              stageIndex: _stage,
              stageCount: _stages.length,
              stageLabel: stage.label,
              stageColor: stage.color,
              onNextStage: _advanceStage,
            ),
          ),

          // 悬浮聊天
          const Positioned(bottom: 110, left: 16, child: GameChatOverlay()),

          // 行动值药丸
          Positioned(
            bottom: 120,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: Text(
                '行动值: ${25 + _stage * 20}',
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 悬浮按钮
          Positioned(
            bottom: 200,
            right: 16,
            child: Column(
              children: [
                _floating(Icons.error_outline),
                const SizedBox(height: 16),
                _floating(Icons.chat_bubble_outline),
              ],
            ),
          ),

          // 底部操作栏（交互）
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GameBottomBar(
              onVote: _showVoteSheet,
              onClue: _showClueBoard,
              onScript: _showScriptSheet,
            ),
          ),
        ],
      ),
    );
  }

  Widget _floating(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white54, width: 1),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

/// 可点击玩家（包一层 onTap，进入身份/交互弹层）。
class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.name,
    required this.url,
    this.speaking = false,
    this.right = false,
  });

  final String name;
  final String url;
  final bool speaking;
  final bool right;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) => _PlayerProfileSheet(name: name),
        );
      },
      child: PlayerAvatarWidget(
        name: name,
        imageUrl: url,
        isSpeaking: speaking,
        isRightSide: right,
      ),
    );
  }
}

/// 玩家身份弹层：姓名 + 性格动作按钮。
class _PlayerProfileSheet extends StatelessWidget {
  const _PlayerProfileSheet({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    const actions = [
      (Icons.emoji_emotions_outlined, '送花'),
      (Icons.mic, '邀请发言'),
      (Icons.visibility_outlined, '观察'),
    ];
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1E2C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '玩家档案',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Hero(
                tag: 'player-$name',
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFFAC5AF0),
                  child: Text(
                    name.characters.first,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '英格兰别墅 · 侦探',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (final a in actions)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('已对 $name 执行「${a.$2}」'),
                            backgroundColor: const Color(0xFF2A2C3A),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(a.$1, color: Colors.white, size: 22),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            a.$2,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 投票弹层：选择一名玩家确认投票。
class _VoteSheet extends StatefulWidget {
  const _VoteSheet();

  @override
  State<_VoteSheet> createState() => _VoteSheetState();
}

class _VoteSheetState extends State<_VoteSheet> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1E2C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '投票选择你怀疑的玩家',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events_outlined, color: Colors.amber, size: 14),
                  SizedBox(width: 4),
                  Text(
                    '仅本人可见，结果揭晓时公布',
                    style: TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(_playerNames.length, (i) {
                  final name = _playerNames[i];
                  final sel = _selected == name;
                  return GestureDetector(
                    key: ValueKey('vote-$name'),
                    onTap: () => setState(() => _selected = name),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 68,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: sel
                            ? const Color(0xFFAC5AF0).withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: sel ? const Color(0xFFAC5AF0) : Colors.white12,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 21,
                            backgroundColor: sel
                                ? const Color(0xFFAC5AF0)
                                : Colors.white.withValues(alpha: 0.1),
                            child: Text(
                              name.characters.first,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  if (_selected != null) {
                    Navigator.of(context).pop(_selected!);
                  }
                },
                child: Container(
                  height: 48,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9B7BFF), Color(0xFF6C3FDC)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    color: _selected == null
                        ? Colors.white12
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _selected == null ? '请先选择玩家' : '确认投票',
                    style: TextStyle(
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
      ),
    ),
  );
  }
}

/// 单条线索。
class _Clue {
  const _Clue(this.title, this.type, this.detail, {this.asset = Icons.tips_and_updates_outlined});

  final String title;
  final String type;
  final String detail;
  final IconData asset;
}

const List<_Clue> _clues = [
  _Clue(
    '染血的台灯',
    '现场',
    '书房台灯底座有一处溅射状血迹，与被害人伤口角度吻合，暗示凶手行凶后曾在书桌前停留。',
    asset: Icons.light_outlined,
  ),
  _Clue(
    '撕碎的稿纸',
    '物品',
    '垃圾桶内发现 30 余页被撕碎的手稿，其中夹着一页写有「今日 0 点前交稿」的催稿便签。',
    asset: Icons.description_outlined,
  ),
  _Clue(
    '署名不明的恐吓信',
    '物品',
    '信封落款为「南方老城 402」，打印字体警告被害人在三天内撤稿，否则倾覆其家业与名声。',
    asset: Icons.mail_outline,
  ),
  _Clue(
    '读者的来电记录',
    '人物',
    '被害人手机昨晚 23:47 接入一通归属地不明的来电，通话时长 4 分 12 秒，之后便再无记录。',
    asset: Icons.smartphone,
  ),
  _Clue(
    '红白相间的围巾',
    '人物',
    '案发现场椅背搭着一条红白相间的织纹围巾，与管家私人饰品的款式高度相似。',
    asset: Icons.checkroom,
  ),
  _Clue(
    '半开的保险柜',
    '现场',
    '书柜后方的隐蔽保险柜呈半开状态，柜内仅剩一份塑封的遗嘱复印件，墨迹仍新。',
    asset: Icons.lock_open,
  ),
  _Clue(
    '雪茄烟灰',
    '人物',
    '地毯边沿发现一处「哈宾娜」牌雪茄烟灰，现场只有受邀编辑的饮食习惯与其相符。',
    asset: Icons.smoke_free,
  ),
  _Clue(
    '「交稿」备忘便签',
    '时间线',
    '桌面便签写着「周三 00:00 前务必交稿，否则……」，字迹被水渍晕开后被重新描过。',
    asset: Icons.note_alt_outlined,
  ),
];

/// 线索板弹层：搜索 / 展开详情 / 搜证收集。
class _ClueBoardSheet extends StatefulWidget {
  const _ClueBoardSheet();

  @override
  State<_ClueBoardSheet> createState() => _ClueBoardSheetState();
}

class _ClueBoardSheetState extends State<_ClueBoardSheet> {
  final Set<String> _collected = {};
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? _clues
        : _clues.where((c) {
            return c.title.contains(_query) || c.type.contains(_query);
          }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
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
            // 标题 + 计数
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  const Icon(Icons.hub, color: Color(0xFF4DD0E1), size: 22),
                  const SizedBox(width: 8),
                  const Text(
                    '线索板',
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
                      color: const Color(0xFF4DD0E1).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '已搜证 ${_collected.length}/${_clues.length}',
                      style: const TextStyle(
                        color: Color(0xFF4DD0E1),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // 搜索框
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (v) => setState(() => _query = v.trim()),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: '搜索线索 / 分类',
                  hintStyle: const TextStyle(color: Colors.white30),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white38,
                    size: 20,
                  ),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.06),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // 线索列表
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text(
                        '未找到相关线索',
                        style: TextStyle(color: Colors.white38, fontSize: 13),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final clue = filtered[i];
                        final got = _collected.contains(clue.title);
                        return _ClueCard(
                          clue: clue,
                          collected: got,
                          onCollect: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              if (got) {
                                _collected.remove(clue.title);
                              } else {
                                _collected.add(clue.title);
                              }
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 线索卡片：分类标签 + 标题 + 可展开详情 + 搜证按钮。
class _ClueCard extends StatefulWidget {
  const _ClueCard({
    required this.clue,
    required this.collected,
    required this.onCollect,
  });

  final _Clue clue;
  final bool collected;
  final VoidCallback onCollect;

  @override
  State<_ClueCard> createState() => _ClueCardState();
}

class _ClueCardState extends State<_ClueCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final clue = widget.clue;
    final got = widget.collected;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: got
            ? const Color(0xFF4DD0E1).withValues(alpha: 0.10)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: got ? const Color(0xFF4DD0E1) : Colors.white12,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4DD0E1).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      clue.asset,
                      color: const Color(0xFF4DD0E1),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clue.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          clue.type,
                          style: const TextStyle(
                            color: Color(0xFF4DD0E1),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: got ? const Color(0xFF4DD0E1) : Colors.white38,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      clue.detail,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    key: const ValueKey('collect-btn'),
                    onTap: widget.onCollect,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: got
                            ? null
                            : const LinearGradient(
                                colors: [
                                  Color(0xFF4DD0E1),
                                  Color(0xFF2CA9B8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        color: got
                            ? Colors.white.withValues(alpha: 0.08)
                            : null,
                        borderRadius: BorderRadius.circular(20),
                        border: got
                            ? Border.all(color: const Color(0xFF4DD0E1))
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            got ? Icons.check_circle : Icons.add_circle_outline,
                            color: got ? const Color(0xFF4DD0E1) : Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            got ? '已搜证' : '搜证',
                            style: TextStyle(
                              color:
                                  got ? const Color(0xFF4DD0E1) : Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
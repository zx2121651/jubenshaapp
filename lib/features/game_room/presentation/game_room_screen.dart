import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/game_room_header.dart';
import '../widgets/player_avatar_widget.dart';
import '../widgets/game_chat_overlay.dart';
import '../widgets/game_bottom_bar.dart';

class GameRoomScreen extends StatefulWidget {
  final String roomId;
  const GameRoomScreen({super.key, required this.roomId});

  @override
  State<GameRoomScreen> createState() => _GameRoomScreenState();
}

class _GameRoomScreenState extends State<GameRoomScreen> {
  @override
  void initState() {
    super.initState();
    // Hide status bar for immersive full-screen game view
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Restore status bar when leaving
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background map (Placeholder) — 淡入渐显
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) =>
                Opacity(opacity: value, child: child),
            child: Container(
              decoration: const BoxDecoration(
                // 深色渐变底纹兜底：外链地图加载失败/离线时仍保留暗场氛围
                gradient: LinearGradient(
                  colors: [Color(0xFF2B2340), Color(0xFF0E1017)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?q=80&w=1200&auto=format&fit=crop',
                  ), // Placeholder map
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black38,
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),

          // Players layer (Mock positioned avatars)
          // Left side
          const Positioned(
            top: 150,
            left: 20,
            child: PlayerAvatarWidget(
              name: '张林路',
              imageUrl:
                  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&auto=format&fit=crop&q=60',
            ),
          ),
          const Positioned(
            top: 240,
            left: 20,
            child: PlayerAvatarWidget(
              name: '爱丽丝',
              imageUrl:
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&auto=format&fit=crop&q=60',
              isSpeaking: true,
            ),
          ),
          const Positioned(
            top: 330,
            left: 20,
            child: PlayerAvatarWidget(
              name: '李子明',
              imageUrl:
                  'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=100&auto=format&fit=crop&q=60',
            ),
          ),
          const Positioned(
            top: 420,
            left: 20,
            child: PlayerAvatarWidget(
              name: '鹿鸣',
              imageUrl:
                  'https://images.unsplash.com/photo-1521119989659-a83eee488004?w=100&auto=format&fit=crop&q=60',
            ),
          ),
          const Positioned(
            top: 510,
            left: 20,
            child: PlayerAvatarWidget(
              name: '胡云闪',
              imageUrl:
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=60',
            ),
          ),

          // Right side
          const Positioned(
            top: 150,
            right: 20,
            child: PlayerAvatarWidget(
              name: '陈侦探',
              imageUrl:
                  'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=100&auto=format&fit=crop&q=60',
              isRightSide: true,
            ),
          ),
          const Positioned(
            top: 240,
            right: 20,
            child: PlayerAvatarWidget(
              name: '孙允珠',
              imageUrl:
                  'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&auto=format&fit=crop&q=60',
              isRightSide: true,
            ),
          ),
          const Positioned(
            top: 330,
            right: 20,
            child: PlayerAvatarWidget(
              name: '李子航',
              imageUrl:
                  'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&auto=format&fit=crop&q=60',
              isRightSide: true,
            ),
          ),
          const Positioned(
            top: 420,
            right: 20,
            child: PlayerAvatarWidget(
              name: '吴晓波',
              imageUrl:
                  'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&auto=format&fit=crop&q=60',
              isRightSide: true,
            ),
          ),
          const Positioned(
            top: 510,
            right: 20,
            child: PlayerAvatarWidget(
              name: '王华丽',
              imageUrl:
                  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&auto=format&fit=crop&q=60',
              isRightSide: true,
            ),
          ),

          // Top Header layer
          const Positioned(top: 0, left: 0, right: 0, child: GameRoomHeader()),

          // Floating Chat Overlay
          const Positioned(bottom: 110, left: 16, child: GameChatOverlay()),

          // Floating "行动值" pill
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
              child: const Text(
                '行动值: 25',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Floating Action Buttons (Right side)
          Positioned(
            bottom: 200,
            right: 16,
            child: Column(
              children: [
                _buildFloatingIcon(Icons.error_outline),
                const SizedBox(height: 16),
                _buildFloatingIcon(Icons.chat_bubble_outline),
              ],
            ),
          ),

          // Bottom Bar
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GameBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingIcon(IconData icon) {
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

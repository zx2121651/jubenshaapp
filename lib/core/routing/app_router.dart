import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/rooms/presentation/rooms_screen.dart';
import '../../features/square/presentation/square_screen.dart';
import '../../features/messages/presentation/messages_screen.dart';
import '../../features/messages/presentation/chat_detail_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/scripts/presentation/script_detail_screen.dart';
import '../../features/game_room/presentation/game_room_screen.dart';
import '../../features/game_room/presentation/clue_board_screen.dart';
import '../../shared/widgets/scaffold_with_bottom_nav_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithBottomNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: 首页 (Home)
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          ],
        ),
        // Tab 2: 组局 (Rooms)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/rooms',
              builder: (context, state) => const RoomsScreen(),
            ),
          ],
        ),
        // Tab 3: 广场 (Square)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/square',
              builder: (context, state) => const SquareScreen(),
            ),
          ],
        ),
        // Tab 4: 消息 (Messages)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/messages',
              builder: (context, state) => const MessagesScreen(),
            ),
          ],
        ),
        // Tab 5: 我的 (Profile)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // 全局路由 (不在底部导航栏之内)
    GoRoute(
      path: '/scripts/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ScriptDetailScreen(scriptId: id);
      },
    ),
    GoRoute(
      path: '/chat/:userName',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final userName = state.pathParameters['userName']!;
        return ChatDetailScreen(userName: userName);
      },
    ),
    GoRoute(
      path: '/room/:roomId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final roomId = state.pathParameters['roomId']!;
        return GameRoomScreen(roomId: roomId);
      },
    ),
    GoRoute(
      path: '/clue-board/:roomId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final roomId = state.pathParameters['roomId']!;
        return ClueBoardScreen(roomId: roomId);
      },
    ),
  ],
);

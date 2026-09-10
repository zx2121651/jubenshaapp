import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/animations.dart';
import '../widgets/home_profile_header.dart';
import '../widgets/home_feature_icons.dart';
import '../widgets/home_banner.dart';
import '../widgets/home_play_section.dart';
import '../widgets/home_feed_list.dart';
import '../widgets/home_category_tabs.dart';
import '../widgets/home_team_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
              child: SizedBox(height: UIConstants.spacingSm),
            ),
            const SliverToBoxAdapter(
              child: Entrance(child: HomeProfileHeader()),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  UIConstants.spacingLg,
                  4,
                  UIConstants.spacingLg,
                  0,
                ),
                child: _HomeSearchEntry(),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: UIConstants.spacingLg),
            ),
            const SliverToBoxAdapter(
              child: Entrance(child: HomeCategoryTabs()),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: UIConstants.spacingLg),
            ),
            const SliverToBoxAdapter(
              child: Entrance(
                delay: Duration(milliseconds: 80),
                offset: Offset(0, 16),
                child: HomeTeamSection(),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: UIConstants.spacingXl),
            ),
            const SliverToBoxAdapter(child: HomeFeatureIcons()),
            const SliverToBoxAdapter(
              child: SizedBox(height: UIConstants.spacingLg),
            ),
            const SliverToBoxAdapter(
              child: Entrance(
                delay: Duration(milliseconds: 120),
                offset: Offset(0, 16),
                child: HomeBanner(),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: UIConstants.spacingXl),
            ),
            const SliverToBoxAdapter(
              child: Entrance(
                delay: Duration(milliseconds: 140),
                offset: Offset(0, 16),
                child: HomePlaySection(),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: UIConstants.spacingXl),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.spacingLg,
              ),
              sliver: const SliverToBoxAdapter(
                child: Entrance(
                  delay: Duration(milliseconds: 160),
                  offset: Offset(0, 16),
                  child: HomeFeedList(),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ), // Bottom padding for nav bar
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

/// 首页顶部搜索入口：主流内容 App 的标志性布局，整宽胶囊 + 搜索图标。
class _HomeSearchEntry extends StatelessWidget {
  const _HomeSearchEntry();

  @override
  Widget build(BuildContext context) {
    return PressScale(
      pressedScale: 0.97,
      onTap: () => context.push('/search'),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: AppTheme.onSurfaceVariant, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '搜索剧本 / 作者 / 标签',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppTheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ),
            Text(
              '搜索',
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

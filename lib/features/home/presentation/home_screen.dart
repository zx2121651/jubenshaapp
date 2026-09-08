import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_motion.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/animations.dart';
import '../widgets/home_profile_header.dart';
import '../widgets/home_feature_icons.dart';
import '../widgets/home_banner.dart';
import '../widgets/home_play_section.dart';
import '../widgets/home_feed_list.dart';

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
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(height: UIConstants.spacingSm),
            ),
            const SliverToBoxAdapter(
              child: Entrance(child: HomeProfileHeader()),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: UIConstants.spacingLg),
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
    );
  }
}

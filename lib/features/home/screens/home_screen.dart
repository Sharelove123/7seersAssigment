import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_colors.dart';
import '../../../core/theme.dart';
import '../controller/home_controller.dart';
import '../widgets/check_in_card.dart';
import '../widgets/guide_card.dart';
import '../widgets/offline_banner.dart';
import '../widgets/dev_menu.dart';
import '../widgets/accent_image.dart';
import '../widgets/community_section.dart';
import '../widgets/custom_bottom_nav.dart';
import '../../../models/guide_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                OfflineBanner(isVisible: state.isOffline),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/icons/logo.png',
                            height: 16,
                            fit: BoxFit.contain,
                          ),
                          GestureDetector(
                            onLongPress: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) => const DevMenu(),
                              );
                            },
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Long-press to open the state simulator',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.darkBox,
                                borderRadius: BorderRadius.zero,
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'H',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        state.greetingText,
                        style: AppTheme.titleStyle(fontSize: 38),
                      ),
                      SubtitleImage(state: state),
                      const SizedBox(height: 32),
                      CheckInCard(
                        isFirstTime: state.isFirstTime,
                        completedCheckIn: state.completedCheckIn,
                        onBegin: () => ref
                            .read(homeControllerProvider.notifier)
                            .completeCheckIn(),
                      ),
                      const SizedBox(height: 32),
                      ..._buildGuidesList(state),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(left: 0, right: 0, bottom: 0, child: const CustomBottomNav()),
      ],
    ),
  );
}

  List<Widget> _buildGuidesList(HomeState state) {
    if (state.isFirstTime) {
      final paidGuide = state.guides.firstWhere(
        (g) => g.id == 'how_to_be_there',
        orElse: () => _getDefaultGuide(
          "how_to_be_there",
          "How to be there\nwhen you don't know how",
          "THIS WEEK'S GUIDE",
          "Paid Guide",
        ),
      );
      final freeGuide = state.guides.firstWhere(
        (g) => g.id == 'talking_it_out',
        orElse: () => _getDefaultGuide(
          "talking_it_out",
          "First-time dads\ntalking it out",
          "FROM YOUR GUIDES",
          "FREE",
        ),
      );

      return [
        GuideCard(guide: paidGuide),
        const SizedBox(height: 32),
        GuideCard(guide: freeGuide),
      ];
    } else if (state.completedCheckIn) {
      final progressGuide = state.guides.firstWhere(
        (g) => g.id == 'struggle_love',
        orElse: () => _getDefaultGuide(
          "struggle_love",
          "You can love it and\nstill struggle",
          "PICK UP WHERE YOU LEFT OFF",
          null,
        ),
      );

      return [
        GuideCard(guide: progressGuide),
        const SizedBox(height: 32),
        CommunitySection(state: state),
      ];
    } else {
      final mainGuide = state.guides.firstWhere(
        (g) => g.id == 'sleepless_month',
        orElse: () => _getDefaultGuide(
          "sleepless_month",
          "The first sleepless month",
          "THIS WEEK'S GUIDE",
          null,
        ),
      );
      return [GuideCard(guide: mainGuide)];
    }
  }

  GuideModel _getDefaultGuide(String id, String title, String category, String? tag) {
    String imageUrl = '';
    String description = 'A soothing read.';
    if (id == 'sleepless_month') {
      imageUrl =
          'https://images.unsplash.com/photo-1544124499-58912cbddaad?w=600&auto=format&fit=crop';
      description = 'A short read on what no one tells you. 6 min.';
    } else if (id == 'struggle_love') {
      imageUrl =
          'https://images.unsplash.com/photo-1516627145497-ae6968895b74?w=600&auto=format&fit=crop';
      description = 'Pick up where you left off';
    } else if (id == 'how_to_be_there') {
      imageUrl =
          'https://images.unsplash.com/photo-1536640712-4d4c36ff0e4e?w=600&auto=format&fit=crop';
      description = "This week's guide for first-time users";
    } else if (id == 'talking_it_out') {
      imageUrl =
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=600&auto=format&fit=crop';
      description = 'From your guides';
    }
    return GuideModel(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      category: category,
      tag: tag,
      order: 1,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_colors.dart';
import '../../../core/theme.dart';
import '../controller/home_controller.dart';
import '../widgets/check_in_card.dart';
import '../widgets/offline_banner.dart';
import '../widgets/dev_menu.dart';
import '../widgets/accent_image.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/guides_section.dart';

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
                      GuidesSection(state: state),
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
}

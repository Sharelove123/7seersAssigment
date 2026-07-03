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
import '../widgets/loading_screen.dart';
import '../widgets/error_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);

    if (state.effectiveStatus == HomeStatus.loading) {
      return const LoadingScreen();
    }

    if (state.effectiveStatus == HomeStatus.error) {
      return ErrorScreen(
        onRetry: () => ref.read(homeControllerProvider.notifier).retryLoading(),
      );
    }

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
                            Row(
                              children: [
                                Image.asset(
                                  'assets/icons/logo.png',
                                  height: 16,
                                  fit: BoxFit.contain,
                                ),
                                if (state.effectiveStatus ==
                                    HomeStatus.successOffline) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.badgePaidBg,
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    child: Text(
                                      'OFFLINE CACHE',
                                      style: AppTheme.bodyStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
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
                                child: Text(
                                  state.userProfile != null &&
                                          state.userProfile!.name.isNotEmpty
                                      ? state.userProfile!.name
                                            .substring(0, 1)
                                            .toUpperCase()
                                      : 'H',
                                  style: const TextStyle(
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: const CustomBottomNav(),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/theme.dart';

class OfflineBanner extends StatelessWidget {
  final bool isVisible;

  const OfflineBanner({super.key, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: isVisible
          ? Container(
              width: double.infinity,
              color: AppColors.offlineBannerBg,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SafeArea(
                bottom: false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/icons/icon-lock.png',
                      width: 16,
                      height: 16,
                      color: AppColors.offlineBannerText,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "You're offline.",
                            style: AppTheme.bodyStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.offlineBannerText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Showing what we already have. New things will appear when you're back.",
                            style: AppTheme.bodyStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.offlineBannerText.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

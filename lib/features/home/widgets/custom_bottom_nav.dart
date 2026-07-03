import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.bottomNavBarBackground,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(assetPath: 'assets/icons/icon1.png', active: true),
          _navItem(assetPath: 'assets/icons/icon2.png', active: false),
          _navItem(assetPath: 'assets/icons/icon3.png', active: false),
          _navItem(assetPath: 'assets/icons/icon4.png', active: false),
          _navItem(assetPath: 'assets/icons/icon5.png', active: false),
        ],
      ),
    );
  }

  Widget _navItem({required String assetPath, required bool active}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          assetPath,
          color: active ? AppColors.activeIndicator : AppColors.inactiveIcon,
          height: 24,
          fit: BoxFit.fitHeight,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.help_outline,
            color: active ? AppColors.activeIndicator : AppColors.inactiveIcon,
            size: 24,
          ),
        ),
        if (active) ...[
          const SizedBox(height: 4),
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: AppColors.activeIndicator,
              shape: BoxShape.circle,
            ),
          ),
        ] else
          const SizedBox(height: 8),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../controller/home_controller.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/theme.dart';

class SubtitleImage extends StatelessWidget {
  final HomeState state;

  const SubtitleImage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    String assetPath;
    if (state.isFirstTime) {
      assetPath = 'assets/icons/caveat (2).png';
    } else if (state.effectiveTimeOfDay == 'Morning') {
      assetPath = 'assets/icons/caveat.png';
    } else {
      assetPath = 'assets/icons/caveat (1).png';
    }

    return Image.asset(
      assetPath,
      height: 24,
      fit: BoxFit.contain,
      alignment: Alignment.centerLeft,
      color: AppColors.textAccent,
      errorBuilder: (context, error, stackTrace) => Text(
        state.accentText,
        style: AppTheme.bodyStyle(fontSize: 16, color: AppColors.textSecondary),
      ),
    );
  }
}

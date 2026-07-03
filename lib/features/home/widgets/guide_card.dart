import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/theme.dart';
import '../../../models/guide_model.dart';

class GuideCard extends StatelessWidget {
  final GuideModel guide;
  final bool forceFullImageBackground;

  const GuideCard({
    super.key,
    required this.guide,
    this.forceFullImageBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSplitLayout =
        guide.category == "THIS WEEK'S GUIDE" &&
        guide.id == 'sleepless_month' &&
        !forceFullImageBackground;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          guide.category,
          style: AppTheme.bodyStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ).copyWith(letterSpacing: 1.2),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.zero,
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: isSplitLayout ? _splitLayout() : _overlayLayout(),
        ),
      ],
    );
  }

  Widget _splitLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _image(height: 180),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: AppColors.cardBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(guide.title, style: AppTheme.titleStyle(fontSize: 20)),
              const SizedBox(height: 4),
              Text(
                guide.description,
                style: AppTheme.bodyStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _overlayLayout() {
    final double height = guide.id == 'struggle_love' ? 240.0 : 160.0;
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Positioned.fill(child: _image()),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.0),
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
          ),
          if (guide.tag != null)
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.zero,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Text(
                  guide.tag!,
                  style: AppTheme.bodyStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ).copyWith(letterSpacing: 0.5),
                ),
              ),
            ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guide.title,
                  style: AppTheme.titleStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _image({double? height}) {
    return Image.network(
      guide.imageUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : _placeholder(height: height),
      errorBuilder: (context, error, stack) => _placeholder(height: height),
    );
  }

  Widget _placeholder({double? height}) {
    return Container(
      width: double.infinity,
      height: height ?? double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE5E4E0), Color(0xFFDCDAD4)],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: AppColors.inactiveIcon,
          size: 28,
        ),
      ),
    );
  }
}

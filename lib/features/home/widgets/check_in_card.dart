import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/theme.dart';

class CheckInCard extends StatelessWidget {
  final bool isFirstTime;
  final bool completedCheckIn;
  final VoidCallback onBegin;

  const CheckInCard({
    super.key,
    required this.isFirstTime,
    required this.completedCheckIn,
    required this.onBegin,
  });

  @override
  Widget build(BuildContext context) {
    final header = isFirstTime ? 'START HERE' : 'THIS WEEK';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (completedCheckIn)
                Row(
                  children: [
                    const Icon(
                      Icons.check,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Done for this week.',
                      style: AppTheme.titleStyle(fontSize: 22),
                    ),
                  ],
                )
              else if (isFirstTime)
                Text(
                  'Your first check-in.',
                  style: AppTheme.titleStyle(fontSize: 22),
                )
              else
                Text(
                  'Five quiet minutes.',
                  style: AppTheme.titleStyle(fontSize: 22),
                ),
              const SizedBox(height: 8),
              Text(
                completedCheckIn
                    ? "Next one's ready Sunday. We'll keep\nthings quiet until then."
                    : isFirstTime
                    ? "Five minutes. There's no wrong answer here."
                    : "Your weekly check-in is ready when you are.\nNo pressure to do it now.",
                style: AppTheme.bodyStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              if (!completedCheckIn) ...[
                const SizedBox(height: 16),
                InkWell(
                  onTap: onBegin,
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Begin',
                          style: AppTheme.bodyStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Image.asset(
                          'assets/icons/arrow.png',
                          width: 14,
                          height: 14,
                          color: AppColors.textPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../controller/home_controller.dart';
import '../../../models/community_post_model.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/theme.dart';

class CommunitySection extends StatelessWidget {
  final HomeState state;

  const CommunitySection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final post = state.communityPosts.isNotEmpty
        ? state.communityPosts.first
        : CommunityPostModel(
            id: 'mock',
            author: 'Marcus',
            authorInitial: 'M',
            text: "Slept through tonight's feed. Felt like winning.",
            group: '2 dads',
            timestamp: '35 minutes ago',
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FROM YOUR COMMUNITY',
          style: AppTheme.bodyStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ).copyWith(letterSpacing: 1.2),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.transparent),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryDarkBox,
                  borderRadius: BorderRadius.zero,
                ),
                alignment: Alignment.center,
                child: Text(
                  post.authorInitial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${post.author} asked a question.',
                      style: AppTheme.bodyStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"${post.text}"',
                      style: AppTheme.bodyStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${post.group} • ${post.timestamp}',
                      style: AppTheme.bodyStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

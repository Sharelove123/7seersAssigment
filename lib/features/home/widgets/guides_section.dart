import 'package:flutter/material.dart';
import '../controller/home_controller.dart';
import '../../../models/guide_model.dart';
import '../widgets/guide_card.dart';
import '../widgets/community_section.dart';

class GuidesSection extends StatelessWidget {
  final HomeState state;

  const GuidesSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final widgets = _getGuidesList(state);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        for (int i = 0; i < widgets.length; i++) ...[
          widgets[i],
          if (i < widgets.length - 1) const SizedBox(height: 32),
        ],
      ],
    );
  }

  List<Widget> _getGuidesList(HomeState state) {
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

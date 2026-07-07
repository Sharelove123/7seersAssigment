import 'package:flutter/material.dart';
import '../controller/home_controller.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/theme.dart';

class SubtitleImage extends StatelessWidget {
  final HomeState state;

  const SubtitleImage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Text(
      state.accentText,
      style: AppTheme.accentStyle(),
    );
  }
}

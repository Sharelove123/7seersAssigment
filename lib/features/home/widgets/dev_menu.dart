import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_colors.dart';
import '../../../core/theme.dart';
import '../controller/home_controller.dart';

class DevMenu extends ConsumerWidget {
  const DevMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final ctrl = ref.read(homeControllerProvider.notifier);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('State Simulator', style: AppTheme.titleStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Toggle between the 4 screen states for review.',
            style: AppTheme.bodyStyle(fontSize: 12),
          ),
          const Divider(height: 24, color: AppColors.border),

          _label('Time of Day'),
          Row(
            children: [
              _chip(context, 'Auto', state.simulatedTimeOfDay == 'Auto', () => ctrl.setSimulatedTimeOfDay('Auto')),
              _chip(context, 'Morning', state.simulatedTimeOfDay == 'Morning', () => ctrl.setSimulatedTimeOfDay('Morning')),
              _chip(context, 'Evening', state.simulatedTimeOfDay == 'Evening', () => ctrl.setSimulatedTimeOfDay('Evening')),
            ],
          ),
          const SizedBox(height: 16),

          _label('User State'),
          Row(
            children: [
              _chip(context, 'Database', state.simulatedFirstTime == null, () => ctrl.setSimulatedFirstTime(null)),
              _chip(context, 'First-Time', state.simulatedFirstTime == true, () => ctrl.setSimulatedFirstTime(true)),
              _chip(context, 'Regular', state.simulatedFirstTime == false, () => ctrl.setSimulatedFirstTime(false)),
            ],
          ),
          const SizedBox(height: 16),

          _label('Network'),
          Row(
            children: [
              _chip(context, 'Device', state.simulatedOffline == null, () => ctrl.setSimulatedOffline(null)),
              _chip(context, 'Offline', state.simulatedOffline == true, () => ctrl.setSimulatedOffline(true)),
              _chip(context, 'Online', state.simulatedOffline == false, () => ctrl.setSimulatedOffline(false)),
            ],
          ),
          const SizedBox(height: 24),

          _label('DB Actions'),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                  ),
                  onPressed: () async {
                    await ctrl.resetUserState();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reset to regular user')),
                      );
                    }
                  },
                  child: Text(
                    'Set Regular',
                    style: AppTheme.bodyStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                  ),
                  onPressed: () async {
                    await ctrl.makeFirstTimeUser();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Set to first-time user')),
                      );
                    }
                  },
                  child: Text(
                    'Set First-Time',
                    style: AppTheme.bodyStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppTheme.bodyStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _chip(BuildContext context, String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: selected ? AppColors.darkBox : AppColors.badgePaidBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              maxLines: 1,
              style: AppTheme.bodyStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class DashboardSectionHeader extends StatelessWidget {
  final String title;

  const DashboardSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Text(title, style: AppTextStyles.titleLarge),
      ),
    );
  }
}

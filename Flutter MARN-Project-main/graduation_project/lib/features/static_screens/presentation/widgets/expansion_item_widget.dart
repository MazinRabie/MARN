import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/features/static_screens/data/models/expansion_model.dart';
import 'package:flutter/material.dart';

class ExpansionItemWidget extends StatelessWidget {
  const ExpansionItemWidget({super.key, required this.item});

  final ExpansionModel item;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withAlpha(10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Material(
        color: AppColors.secondaryContainer,
        shadowColor: AppColors.shadowDark,
        elevation: 1.5,
        clipBehavior: Clip.antiAlias,
        borderRadius: borderRadius,
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.primary,
          title: _buildTitle(),
          children: [_buildAnswer()],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        if (item.icon != null) ...[item.icon!, const SizedBox(width: 12)],
        Expanded(child: Text(item.title, style: AppTextStyles.bodyBold)),
      ],
    );
  }

  Widget _buildAnswer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Text(item.result, style: AppTextStyles.bodyMedium),
    );
  }
}

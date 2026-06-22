import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key, required this.onSuggestionSelected});

  final ValueChanged<String> onSuggestionSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.smart_toy,
            color: AppColors.primary,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          LocaleKeys.chatbotMessagesHelpHeader.tr(),
          style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          LocaleKeys.chatbotMessagesHelpDesc.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            _buildSuggestionChip(LocaleKeys.chatbotPromptsFindProperties.tr()),
            _buildSuggestionChip(LocaleKeys.chatbotPromptsWhatCanYouDo.tr()),
            _buildSuggestionChip(LocaleKeys.chatbotPromptsGettingStarted.tr()),
          ],
        ),
      ],
    );
  }

  Widget _buildSuggestionChip(String text) {
    return InkWell(
      onTap: () => onSuggestionSelected(text),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

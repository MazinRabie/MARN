import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/routes/routes.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/profile_image_widget.dart';
import 'package:MARN/features/main_layout/domain/entities/roommate_match_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoommateMatchCard extends StatefulWidget {
  final RoommateMatchEntity match;
  const RoommateMatchCard({super.key, required this.match});

  @override
  State<RoommateMatchCard> createState() => _RoommateMatchCardState();
}

class _RoommateMatchCardState extends State<RoommateMatchCard> {
  bool _isExpanded = false;

  Color _getScoreColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 50) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final match = widget.match;
    final scoreColor = _getScoreColor(match.compatibilityScore);

    return CustomGeneralContainer(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          context.push(
            AppRoutes.profileScreen,
            extra: ProfileScreenArguments(userId: match.userId),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile image or placeholder
                  ProfileImageWidget(imagePath: match.profileImage, radius: 30),
                  const SizedBox(width: 12),
                  // Roommate Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          match.fullName,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.primarySoft),
                          ),
                          child: Text(
                            match.badge,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          LocaleKeys.roommateSearchStatus.tr(
                            namedArgs: {
                              'status': match.searchStatus.displayName,
                            },
                          ),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Compatibility Score Badge
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: scoreColor.withOpacity(0.3),
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: scoreColor.withOpacity(0.1),
                          child: Text(
                            "${match.compatibilityScore.toStringAsFixed(0)}%",
                            style: AppTextStyles.labelMedium.copyWith(
                              color: scoreColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        LocaleKeys.roommateCompatibility.tr(),
                        style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 9,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Divider and Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: const Divider(height: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
                vertical: 4.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textTertiary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          context.push(
                            AppRoutes.chatScreen,
                            extra: ChatScreenArguments(userId: match.userId),
                          );
                        },
                        icon: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          LocaleKeys.roommateChatWith.tr(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Expanded Traits List
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 16),
                    if (match.topMatchingTraits.isNotEmpty) ...[
                      _sectionTitle(
                        LocaleKeys.roommateMatchingTraits.tr(),
                        AppColors.success,
                        Icons.check_circle_outline_rounded,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: match.topMatchingTraits.map((trait) {
                          return _traitBadge(trait, AppColors.success);
                        }).toList(),
                      ),
                    ],
                    if (match.mismatchedTraits.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _sectionTitle(
                        LocaleKeys.roommateMismatchedTraits.tr(),
                        AppColors.warning,
                        Icons.info_outline_rounded,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: match.mismatchedTraits.map((trait) {
                          return _traitBadge(trait, AppColors.warning);
                        }).toList(),
                      ),
                    ],
                    if (match.dealbreakersFound.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _sectionTitle(
                        LocaleKeys.roommateDealbreakers.tr(),
                        AppColors.error,
                        Icons.cancel_outlined,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: match.dealbreakersFound.map((trait) {
                          return _traitBadge(trait, AppColors.error);
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text, Color color, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTextStyles.labelMedium.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _traitBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

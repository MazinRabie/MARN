import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/features/chatboot/domain/entities/assistant_session_entity.dart';
import 'package:flutter/material.dart';

class SessionListTile extends StatelessWidget {
  final AssistantSessionEntity session;
  final bool isSelected;
  final VoidCallback onRenamePressed;
  final VoidCallback onTap;

  const SessionListTile({
    super.key,
    required this.session,
    required this.isSelected,
    required this.onRenamePressed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withOpacity(0.08)
            : AppColors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: AppColors.primary.withOpacity(0.3))
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.2)
                : AppColors.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.chat_bubble_rounded,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            size: 20,
          ),
        ),
        title: Text(
          session.sessionName.isNotEmpty
              ? session.sessionName
              : 'محادثة غير مسماة',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: session.lastMessagePreview != null
            ? Text(
                session.lastMessagePreview!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: IconButton(
          icon: const Icon(Icons.edit_outlined, size: 20),
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          onPressed: onRenamePressed,
        ),
        onTap: onTap,
      ),
    );
  }
}

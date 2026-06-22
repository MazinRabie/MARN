import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/core/widgets/date_formatter.dart';
import 'package:MARN/features/main_layout/domain/entities/notification_entity.dart';
import 'package:MARN/features/main_layout/presentation/state_management/cubit/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/features/main_layout/presentation/ui/widgets/notification_helper.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({super.key, required this.notification});

  final NotificationEntity notification;

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  late bool isUnread;

  @override
  void initState() {
    super.initState();
    isUnread = !widget.notification.isRead;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            if (expanded) {
              if (isUnread) {
                context.read<NotificationCubit>().markNotificationAsRead(
                  widget.notification.id,
                );
                setState(() {
                  isUnread = false;
                });
              }
            }
          },
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),

          /// 🔹 Leading Icon (Emoji)
          leading: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Text(
              getNotificationEmoji(widget.notification.type),
              style: const TextStyle(fontSize: 22),
            ),
          ),

          /// 🔹 Title & Type Badge
          title: Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(widget.notification.title, style: AppTextStyles.bodyBold),
              if (widget.notification.type?.displayName.isNotEmpty ?? false)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.notification.type?.displayName ?? '',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          /// 🔹 Unread dot
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isUnread)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),

          /// 🔹 Expanded Content
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(widget.notification.body, style: AppTextStyles.bodySmall),
                if (widget.notification.actionType?.displayName.isNotEmpty ??
                    false) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.label_outline_rounded,
                        color: AppColors.textTertiary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${LocaleKeys.mainLayoutNotificationsAction.tr()}: ${widget.notification.actionType?.displayName ?? ''}",
                        style: AppTextStyles.metadata.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: AppColors.textTertiary,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormatter.format(widget.notification.createdAt),
                      style: AppTextStyles.metadata,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (widget.notification.actionType != null)
              CustomGeneralButton(
                onPressed: () => handleNotificationAction(
                  context,
                  actionType: widget.notification.actionType,
                  actionId: widget.notification.actionId,
                ),
                text: getNotificationActionText(widget.notification.actionType),
              ),
          ],
        ),
      ),
    );
  }
}

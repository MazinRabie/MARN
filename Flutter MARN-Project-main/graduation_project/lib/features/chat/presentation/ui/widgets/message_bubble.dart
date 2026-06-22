import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/features/chat/domain/entities/chat_message_entity.dart';
import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/enums/utils/enum_helper.dart';
import 'package:MARN/core/widgets/show_report_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessageEntity message;
  final String otherUserId;

  const MessageBubble({
    super.key,
    required this.message,
    required this.otherUserId,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMe =
        message.senderId.trim().toLowerCase() !=
            otherUserId.trim().toLowerCase() ||
        message.senderId == "me";

    Widget bubbleWidget = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primary : AppColors.primaryContainer,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: isMe
              ? const Radius.circular(16)
              : const Radius.circular(0),
          bottomRight: isMe
              ? const Radius.circular(0)
              : const Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: isMe
                ? AppTextStyles.chatMessageMe
                : AppTextStyles.chatMessageOther,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.sentAt.toString(),
                style: isMe
                    ? AppTextStyles.chatTimeMe
                    : AppTextStyles.chatTimeOther,
              ),
            ],
          ),
        ],
      ),
    );

    Offset tapPosition = Offset.zero;

    bubbleWidget = GestureDetector(
      onTapDown: (details) {
        tapPosition = details.globalPosition;
      },
      onTap: () async {
        final overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        final result = await showMenu<String>(
          context: context,
          position: RelativeRect.fromRect(
            Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 30, 30),
            Offset.zero & overlay.size,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: AppColors.surface,
          elevation: 8,
          items: [
            PopupMenuItem(
              value: 'copy',
              child: Row(
                children: [
                  const Icon(
                    Icons.copy_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(LocaleKeys.chatMessagesCopy.tr(), style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
            if (!isMe) ...[
              PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    const Icon(
                      Icons.report_gmailerrorred_rounded,
                      color: AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      LocaleKeys.chatMessagesReport.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );

        if (result == 'copy') {
          Clipboard.setData(ClipboardData(text: message.content));
        } else if (result == 'report') {
          showReportDialog(
            context,
            reportableType:
                EnumHelper.getEnum(
                  context,
                  EnumType.reportableTypes,
                )?.firstWhere(
                  (e) => e.name.toLowerCase() == 'message',
                  orElse: () =>
                      EnumItem(id: 0, name: 'message', displayName: 'Message'),
                ) ??
                EnumItem(id: 0, name: 'message', displayName: 'Message'),
            reportableTargetId: message.id,
          );
        }
      },
      child: bubbleWidget,
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: bubbleWidget,
      ),
    );
  }
}

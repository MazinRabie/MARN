import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/routes/routes.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/features/chat/domain/entities/chat_user_entity.dart';
import 'package:MARN/core/widgets/profile_image_widget.dart';
import 'package:MARN/features/chat/presentation/ui/widgets/online_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/widgets/date_formatter.dart';

class ChatUserCard extends StatelessWidget {
  final ChatUserEntity user;

  const ChatUserCard({super.key, required this.user});

  String _formatDate(String dateStr) {
    final dt = DateTime.tryParse(dateStr);
    if (dt != null) {
      return DateFormatter.format(dt);
    }
    return dateStr;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 8),
      leading: Stack(
        children: [
          ProfileImageWidget(
            imagePath: user.profileImage,
            isDeleted: user.isDeleted,
          ),
          if (user.isOnline) OnlineState(isOnline: user.isOnline),
        ],
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              user.userName,
              style: AppTextStyles.chatUserName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          if (user.lastMessage != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 4),
              child: Text(
                _formatDate(user.lastMessage!.sentAt),
                style: AppTextStyles.chatMessageTime,
              ),
            ),
        ],
      ),
      subtitle: user.lastMessage != null
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (user.lastMessage!.isMine) ...[
                  Text(
                    LocaleKeys.chatMessagesYouPrefix.tr(),
                    style: AppTextStyles.chatUserSubtitle,
                  ),
                ],
                Expanded(
                  child: Text(
                    user.lastMessage!.content.replaceAll('\n', ' '),
                    style: AppTextStyles.chatUserSubtitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (user.unreadCount > 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      user.unreadCount.toString(),
                      style: AppTextStyles.chatMessageTime,
                    ),
                  ),
                ],
              ],
            )
          : SizedBox(),
      horizontalTitleGap: 10,
      onTap: () async {
        context.push(
          AppRoutes.chatScreen,
          extra: ChatScreenArguments(userId: user.id, isOnline: user.isOnline),
        );
      },
    );
  }
}

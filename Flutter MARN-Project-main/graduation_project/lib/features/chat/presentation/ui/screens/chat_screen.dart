import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/routes/routes.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/profile_image_widget.dart';
import 'package:MARN/features/chat/domain/entities/chat_message_entity.dart';
import 'package:MARN/features/chat/presentation/state_management/cubit/message_cubit.dart';
import 'package:MARN/features/chat/presentation/ui/widgets/message_bubble.dart';
import 'package:MARN/features/profile/domain/entities/profile_entity.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_cubit.dart';
import 'package:MARN/features/chat/presentation/ui/widgets/send_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/enums/utils/enum_helper.dart';
import 'package:MARN/core/widgets/show_report_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final bool? isOnline;
  const ChatScreen({super.key, required this.userId, this.isOnline});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  late MessageCubit messageCubit;
  List<ChatMessageEntity> messages = [];
  bool? isOnline;
  ProfileEntity? profileEntity;

  @override
  void initState() {
    super.initState();
    isOnline = widget.isOnline;
    messageCubit = context.read<MessageCubit>();
    messageCubit.getChatHistory(widget.userId);
    messageCubit.connect();
    messageCubit.markChatAsRead(otherUserId: widget.userId);
    messageCubit.activeChatWith(otherUserId: widget.userId);
    messageCubit.listenToNewMessages();
    messageCubit.listenToUserOnline();
  }

  @override
  void dispose() {
    messageCubit.leaveActiveChat(otherUserId: widget.userId);
    messages.clear();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.transparent,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is GetUserProfileLoaded) {
              setState(() {
                profileEntity = state.userProfileEntity;
              });
            }
          },
          builder: (context, state) {
            if (profileEntity == null) {
              return const CircularProgressIndicator(color: Colors.white);
            }
            return Row(
              children: [
                ProfileImageWidget(
                  imagePath: profileEntity!.profileImage,
                  radius: 20,
                  isDeleted: profileEntity!.accountStatus.name.toLowerCase() == "deleted",
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        profileEntity!.fullName,
                        style: AppTextStyles.chatName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      if (isOnline != null)
                        Text(
                          isOnline! ? LocaleKeys.chatStatusOnline.tr() : LocaleKeys.chatStatusOffline.tr(),
                          style: AppTextStyles.chatMessageTime.copyWith(
                            color: isOnline! ? AppColors.success : AppColors.grey,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == "ShowProfile") {
                context.push(
                  AppRoutes.profileScreen,
                  extra: ProfileScreenArguments(userId: widget.userId),
                );
              } else if (value == "Report") {
                showReportDialog(
                  context,
                  reportableType:
                      EnumHelper.getEnum(
                        context,
                        EnumType.reportableTypes,
                      )?.firstWhere(
                        (e) => e.name.toLowerCase() == 'user',
                        orElse: () =>
                            EnumItem(id: 0, name: 'user', displayName: 'User'),
                      ) ??
                      EnumItem(id: 0, name: 'user', displayName: 'User'),
                  reportableTargetId: widget.userId,
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: "ShowProfile", child: Text(LocaleKeys.chatButtonsShowProfile.tr())),
              PopupMenuItem(value: "Report", child: Text(LocaleKeys.chatButtonsReportUser.tr())),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            BlocConsumer<MessageCubit, MessageState>(
              listener: (context, state) {
                if (state is MessageSentFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(LocaleKeys.chatSnackbarFailedToSendMessage.tr()),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is ListenToMessages) {
                  final newMessage = state.message;
                  if (newMessage.senderId.toLowerCase() ==
                          widget.userId.toLowerCase() ||
                      newMessage.receiverId.toLowerCase() ==
                          widget.userId.toLowerCase()) {
                    final exists = messages.any((m) => m.id == newMessage.id);
                    if (exists) return;
                    messages.insert(0, newMessage);
                    if (newMessage.senderId.toLowerCase() ==
                        widget.userId.toLowerCase()) {
                      messageCubit.markChatAsRead(otherUserId: widget.userId);
                    }
                    setState(() {});
                  }
                } else if (state is ListenToUserOnline) {
                  final userStatus = state.userStatus;
                  if (userStatus.keys.first.toLowerCase() ==
                      widget.userId.toLowerCase()) {
                    setState(() {
                      isOnline = userStatus.values.first == "online";
                    });
                  }
                } else if (state is HistoryLoaded) {
                  final newMessage = state.messages;
                  messages.addAll(newMessage);
                  setState(() {});
                }
              },
              builder: (context, state) {
                if (state is MessageFailure) {
                  return Expanded(
                    child: Center(child: Text(state.errorMessage)),
                  );
                } else if (state is MessageLoading) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return MessageBubble(
                          otherUserId: widget.userId,
                          message: messages[index],
                        );
                      },
                    ),
                  );
                }
              },
            ),
            SendMessageWidget(
              scrollController: _scrollController,
              receiverId: widget.userId,
              isDeleted: [
                "banned",
                "deleted",
              ].contains(profileEntity?.accountStatus.name.toLowerCase()),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:MARN/core/services/shared_preferences_helper.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/core/widgets/custom_divider.dart';
import 'package:MARN/core/widgets/search_widget.dart';
import 'package:MARN/features/chat/domain/entities/chat_user_entity.dart';
import 'package:MARN/features/chat/presentation/state_management/cubit/message_cubit.dart';
import 'package:MARN/features/chat/presentation/ui/widgets/chat_user_card.dart';
import 'package:MARN/features/profile/data/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MARN/core/widgets/top_bounce_only_scroll_physics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class ListChatsScreen extends StatefulWidget {
  const ListChatsScreen({super.key});
  @override
  State<ListChatsScreen> createState() => _ListChatsScreenState();
}

class _ListChatsScreenState extends State<ListChatsScreen> {
  List<ChatUserEntity> users = [];
  final myId = ProfileModel.fromJson(
    jsonDecode(SharedPreferencesHelper.getString(LocalStorageVariables.user)!),
  ).id;

  late MessageCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<MessageCubit>();
    cubit.getUsers();
    cubit.listenToNewMessages();
    cubit.listenToUserOnline();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SafeArea(
        child: BlocConsumer<MessageCubit, MessageState>(
          listener: (context, state) {
            if (state is ChatFailure) {
              buildSnackBar(
                context,
                isError: true,
                message: state.errorMessage,
              );
            }
            if (state is ListenToMessages) {
              final newMessage = state.message;
              final myIdLower = myId.toLowerCase();
              final senderIdLower = newMessage.senderId.toLowerCase();
              final receiverIdLower = newMessage.receiverId.toLowerCase();
              final isMine = senderIdLower == myIdLower;
              final otherUserIdLower = isMine ? receiverIdLower : senderIdLower;
              final index = users.indexWhere(
                (u) => u.id.toLowerCase() == otherUserIdLower,
              );
              if (index != -1) {
                final user = users.removeAt(index);
                final updatedLastMsg = LastMessageEntity(
                  content: newMessage.content,
                  sentAt: newMessage.sentAt,
                  isMine: isMine,
                );
                user.lastMessage = updatedLastMsg;
                if (!isMine &&
                    cubit.activeChatUserId?.toLowerCase() != otherUserIdLower) {
                  user.unreadCount += 1;
                }
                setState(() {
                  users.insert(0, user);
                });
              } else {
                cubit.getUsers();
              }
            }
            if (state is MarMessageAsReadSuccess) {
              final index = users.indexWhere(
                (u) => u.id.toLowerCase() == state.otherUserId.toLowerCase(),
              );
              if (index != -1) {
                setState(() {
                  users[index].unreadCount = 0;
                });
              }
            }
            if (state is ListenToUserOnline) {
              final userStatus = state.userStatus;
              final index = users.indexWhere(
                (u) =>
                    u.id.toLowerCase() == userStatus.keys.first.toLowerCase(),
              );
              if (index != -1) {
                setState(() {
                  users[index].isOnline = userStatus.values.first == "online";
                });
              }
            }
            if (state is GetUsersLoaded) {
              setState(() {
                users = state.users;
              });
            }
          },
          buildWhen: (previous, current) {
            return current is ChatLoading ||
                current is GetUsersLoaded ||
                current is SearchLoaded ||
                current is ListenToMessages ||
                current is ListenToUserOnline ||
                current is MarMessageAsReadSuccess;
          },
          builder: (context, state) {
            return Column(
              children: [
                SearchWidget(
                  hintText: LocaleKeys.chatPlaceholdersSearchUsers.tr(),
                  controller: searchController,
                  onPressed: (value) {
                    context.read<MessageCubit>().searchUsers(query: value);
                  },
                  onPressedClose: () {
                    context.read<MessageCubit>().getUsers();
                  },
                ),
                if (state is ChatLoading)
                  Expanded(child: Center(child: buildLoading())),
                if (state is GetUsersLoaded)
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async {
                        context.read<MessageCubit>().getUsers();
                      },
                      child: users.isEmpty
                          ? ListView(
                              physics: const TopBounceOnlyScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics(),
                                ),
                              ),
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Center(
                                    child: Text(
                                      LocaleKeys.chatPlaceholdersNoChatsYet.tr(),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              physics: const TopBounceOnlyScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics(),
                                ),
                              ),
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                return ChatUserCard(user: users[index]);
                              },
                            ),
                    ),
                  ),
                if (state is SearchLoaded)
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async {
                        context.read<MessageCubit>().getUsers();
                      },
                      child: _buildSearchResults(state.users),
                    ),
                  ),
                if (state is ListenToMessages ||
                    state is MarMessageAsReadSuccess ||
                    state is ListenToUserOnline)
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async {
                        context.read<MessageCubit>().getUsers();
                      },
                      child: ListView.builder(
                        physics: const TopBounceOnlyScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                        ),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return ChatUserCard(user: users[index]);
                        },
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<ChatUserEntity> users) {
    final recentChats = users.where((u) => u.lastMessage != null).toList();
    final otherUsers = users.where((u) => u.lastMessage == null).toList();

    return ListView(
      physics: const TopBounceOnlyScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
      ),
      children: [
        CustomDivider(text: LocaleKeys.chatPlaceholdersRecentChats.tr()),
        if (recentChats.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(LocaleKeys.chatPlaceholdersNoRecentChats.tr()),
            ),
          )
        else
          ...recentChats.map((user) => ChatUserCard(user: user)),
        CustomDivider(text: LocaleKeys.chatPlaceholdersOtherUsers.tr()),
        if (otherUsers.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(LocaleKeys.chatPlaceholdersNoOtherUsers.tr()),
            ),
          )
        else
          ...otherUsers.map((user) => ChatUserCard(user: user)),
      ],
    );
  }
}

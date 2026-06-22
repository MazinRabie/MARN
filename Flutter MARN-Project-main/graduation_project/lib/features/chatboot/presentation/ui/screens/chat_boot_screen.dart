import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/features/chatboot/domain/entities/assistant_message_entity.dart';
import 'package:MARN/features/chatboot/presentation/state_management/cubit/assistant_cubit.dart';
import 'package:MARN/features/chatboot/presentation/ui/widgets/assistant_app_bar.dart';
import 'package:MARN/features/chatboot/presentation/ui/widgets/assistant_input_widget.dart';
import 'package:MARN/features/chatboot/presentation/ui/widgets/assistant_message_bubble.dart';
import 'package:MARN/features/chatboot/presentation/ui/widgets/assistant_typing_bubble.dart';
import 'package:MARN/features/chatboot/presentation/ui/widgets/chat_history_drawer.dart';
import 'package:MARN/features/chatboot/presentation/ui/widgets/welcome_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class ChatBootScreen extends StatefulWidget {
  const ChatBootScreen({super.key});

  @override
  State<ChatBootScreen> createState() => _ChatBootScreenState();
}

class _ChatBootScreenState extends State<ChatBootScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AssistantAppBar(
        onHistoryPressed: () {
          _scaffoldKey.currentState?.openEndDrawer();
        },
      ),
      endDrawer: ChatHistoryDrawer(scaffoldKey: _scaffoldKey),
      body: SafeArea(
        child: BlocConsumer<AssistantCubit, AssistantState>(
          listener: (context, state) {
            if (state is AssistantError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final messages = state is AssistantMessagesLoaded
                ? state.messages
                : context.read<AssistantCubit>().messages;
            final isChatLoading = state is AssistantLoading && messages.isEmpty;

            return Column(
              children: [
                Expanded(
                  child: isChatLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : messages.isEmpty
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          child: Column(
                            children: [
                              WelcomeSection(
                                onSuggestionSelected: (text) {
                                  context.read<AssistantCubit>().sendMessage(
                                    text,
                                  );
                                },
                              ),
                              const SizedBox(height: 48),
                              _buildBotMessage(
                                LocaleKeys.chatbotMessagesWelcomeGreeting.tr(),
                                DateFormat('hh:mm a').format(DateTime.now()),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message =
                                messages[messages.length - 1 - index];

                            if (message.pending) {
                              return const AssistantTypingBubble();
                            }

                            return AssistantMessageBubble(message: message);
                          },
                        ),
                ),
                AssistantInputWidget(
                  scrollController: _scrollController,
                  onSend: (text) {
                    if (text.trim().isNotEmpty) {
                      context.read<AssistantCubit>().sendMessage(text.trim());
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBotMessage(String text, String time) {
    return AssistantMessageBubble(
      message: AssistantMessageEntity(
        messageId: 'welcome',
        role: 'assistant',
        content: text,
        createdAt: DateTime.now(),
      ),
    );
  }
}

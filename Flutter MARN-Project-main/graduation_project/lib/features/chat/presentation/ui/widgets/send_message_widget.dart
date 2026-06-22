import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/features/chat/presentation/state_management/cubit/message_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';


class SendMessageWidget extends StatefulWidget {
  const SendMessageWidget({
    super.key,
    required this.scrollController,
    required this.receiverId,
    required this.isDeleted,
  });

  final ScrollController scrollController;
  final String receiverId;
  final bool isDeleted;

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isDeleted
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.errorContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.error.withOpacity(0.3)),
            ),
            child: Text(
              LocaleKeys.chatStatusUserDeletedNotice.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.chatUserSubtitle.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      hintText: LocaleKeys.chatPlaceholdersTypeMessage.tr(),
                      hintStyle: AppTextStyles.bodyHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send),
                  color: AppColors.primary,
                  onPressed: () {
                    if (_controller.text.isEmpty) return;
                    context.read<MessageCubit>().sendMessage(
                      receiverId: widget.receiverId.toLowerCase(),
                      content: _controller.text.trim(),
                    );
                    setState(() {
                      _controller.clear();
                    });

                    Future.delayed(const Duration(milliseconds: 100), () {
                      if (!widget.scrollController.hasClients) return;

                      widget.scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    });
                  },
                ),
              ],
            ),
          );
  }
}

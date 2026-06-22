import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/features/chatboot/presentation/ui/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';

class AssistantTypingBubble extends StatelessWidget {
  const AssistantTypingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: const BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: const TypingIndicator(),
        ),
      ),
    );
  }
}

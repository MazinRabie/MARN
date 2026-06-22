import 'package:flutter/material.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';

class SearchWidget extends StatelessWidget {
  final String hintText;
  final Function(String) onPressed;
  final VoidCallback? onPressedClose;
  final TextEditingController controller;
  final Widget? actionWidget;

  const SearchWidget({
    super.key,
    required this.hintText,
    required this.onPressed,
    required this.controller,
    this.onPressedClose,
    this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, child) {
          return TextField(
            controller: controller,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                onPressed(value.trim());
                FocusScope.of(context).unfocus();
              }
            },
            style: AppTextStyles.bodyBold,
            cursorColor: AppColors.primary,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.bodyHint,
              border: InputBorder.none,
              prefixIcon: IconButton(
                icon: const Icon(Icons.search, color: AppColors.primary),
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    onPressed(controller.text.trim());
                    FocusScope.of(context).unfocus();
                  }
                },
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (value.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        if (onPressedClose != null) {
                          onPressedClose!();
                        }
                        controller.clear();
                      },
                    ),
                  actionWidget ?? SizedBox.shrink(),
                ],
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
            ),
          );
        },
      ),
    );
  }
}

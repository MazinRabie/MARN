import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/features/chatboot/domain/entities/assistant_session_entity.dart';
import 'package:MARN/features/chatboot/presentation/state_management/cubit/assistant_cubit.dart';
import 'package:flutter/material.dart';

class RenameSessionDialog extends StatefulWidget {
  const RenameSessionDialog({
    super.key,
    required this.session,
    required this.assistantCubit,
  });

  final AssistantSessionEntity session;
  final AssistantCubit assistantCubit;

  @override
  State<RenameSessionDialog> createState() => _RenameSessionDialogState();
}

class _RenameSessionDialogState extends State<RenameSessionDialog> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.session.sessionName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.surface,
      title: Text(
        'إعادة تسمية المحادثة',
        style: AppTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'اسم المحادثة الجديد',
            hintStyle: AppTextStyles.bodyHint,
            filled: true,
            fillColor: AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال اسم صحيح';
            }
            if (value.length > 200) {
              return 'الاسم طويل جداً (الحد الأقصى 200 حرف)';
            }
            return null;
          },
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'إلغاء',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newName = _nameController.text.trim();
              widget.assistantCubit.renameSession(
                sessionId: widget.session.sessionId,
                sessionName: newName,
              );
              Navigator.pop(context);
            }
          },
          child: Text(
            'حفظ',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

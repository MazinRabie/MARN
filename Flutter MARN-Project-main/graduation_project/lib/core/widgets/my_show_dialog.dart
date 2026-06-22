import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';
void myShowDialog(
  BuildContext context, {
  required String title,
  required String content,
  required VoidCallback onConfirm,
  required String confirmText,
}) => showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(LocaleKeys.commonCancel.tr()),
      ),
      TextButton(
        onPressed: () {
          onConfirm();
          Navigator.pop(context);
        },
        child: Text(confirmText),
      ),
    ],
  ),
);

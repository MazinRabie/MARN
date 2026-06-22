import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class HeadLineWidget extends StatelessWidget {
  const HeadLineWidget({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        title,
        style: AppTextStyles.headlineSmall,
        textAlign: TextAlign.start,
      ),
    );
  }
}

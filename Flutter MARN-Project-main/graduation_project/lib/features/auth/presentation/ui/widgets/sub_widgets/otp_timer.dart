import 'dart:async';
import 'package:flutter/material.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

class OtpTimer extends StatefulWidget {
  const OtpTimer({super.key, required this.onTimerEnd});

  final Function() onTimerEnd;

  @override
  State<OtpTimer> createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  int seconds = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return seconds > 0
        ? Text(LocaleKeys.authOtpResendTimer.tr(args: [seconds.toString()]), style: AppTextStyles.bodyLarge)
        : TextButton(
            child: Text(LocaleKeys.authOtpResendButton.tr()),
            onPressed: () {
              widget.onTimerEnd();
              seconds = 60;
              startTimer();
            },
          );
  }
}

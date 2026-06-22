import 'dart:async';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/features/main_layout/domain/entities/signalr_notification_entity.dart';
import 'package:flutter/material.dart';
import 'package:MARN/features/main_layout/presentation/ui/widgets/notification_helper.dart';

/// ============================
/// GLOBAL STATE
/// ============================
OverlayEntry? _overlayEntry;

/// ============================
/// PUBLIC FUNCTION
/// ============================
void notificationToster(
  BuildContext context, {
  required SignalrNotificationEntity notification,
  Duration duration = const Duration(seconds: 4),
}) {
  final overlay = Overlay.of(context);

  // remove old toast if exists
  _overlayEntry?.remove();

  _overlayEntry = OverlayEntry(
    builder: (context) => _FloatingNotification(
      notification: notification,
      duration: duration,
      onDismiss: () {
        _overlayEntry?.remove();
        _overlayEntry = null;
      },
    ),
  );

  overlay.insert(_overlayEntry!);
}

/// ============================
/// UI WIDGET
/// ============================
class _FloatingNotification extends StatefulWidget {
  final SignalrNotificationEntity notification;
  final Duration duration;
  final VoidCallback onDismiss;

  const _FloatingNotification({
    required this.notification,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_FloatingNotification> createState() => _FloatingNotificationState();
}

class _FloatingNotificationState extends State<_FloatingNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fade = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    Future.delayed(widget.duration, () async {
      if (mounted) {
        await _controller.reverse();
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _slide,
          child: FadeTransition(
            opacity: _fade,
            child: GestureDetector(
              onTap: () {
                handleNotificationAction(
                  context,
                  actionType: widget.notification.actionType,
                  actionId: widget.notification.actionId,
                );
                widget.onDismiss();
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primarySoft, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        getNotificationEmoji(widget.notification.type),
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.notification.title,
                            style: AppTextStyles.bodyBold.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (widget.notification.body.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              widget.notification.body,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (widget.notification.actionType != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.primary.withOpacity(0.7),
                        size: 14,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

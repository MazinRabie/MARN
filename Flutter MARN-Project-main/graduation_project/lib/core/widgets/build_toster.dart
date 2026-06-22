import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// ============================
/// GLOBAL STATE
/// ============================
OverlayEntry? _overlayEntry;

/// ============================
/// PUBLIC FUNCTION
/// ============================
void buildToster(
  BuildContext context, {
  required String message,
  String? detail,
  Duration duration = const Duration(seconds: 3),
}) {
  final overlay = Overlay.of(context);

  // remove old toast if exists
  _overlayEntry?.remove();

  _overlayEntry = OverlayEntry(
    builder: (context) => _FloatingNotification(
      message: message,
      detail: detail,
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
  final String message;
  final String? detail;
  final Duration duration;
  final VoidCallback onDismiss;

  const _FloatingNotification({
    required this.message,
    this.detail,
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
      await _controller.reverse();
      widget.onDismiss();
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
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.notifications_active, color: AppColors.primary),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.message, style: AppTextStyles.bodyBold),
                        if (widget.detail != null)
                          Text(widget.detail!, style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

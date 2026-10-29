import 'dart:async';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// CRITICAL: Link the messenger key here
// scaffoldMessengerKey: SmartSnackBars.messengerKey,

enum NotificationType { success, error, warning, info }

class SmartSnackBars {
  // Global Key to access ScaffoldMessenger without Context
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Show a standard SnackBar styled with our custom layout
  static void show({
    required String message,
    NotificationType type = NotificationType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  })
  {
    final messenger = messengerKey.currentState;

    // Clear any existing snackbars immediately
    messenger?.removeCurrentSnackBar();

    messenger?.showSnackBar(
      SnackBar(
        duration: duration,
        elevation: 0,
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.all(16),
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        content: SmartSnackBarContentWidget(
          message: message,
          type: type,
          actionLabel: actionLabel,
          onAction: onAction,
          onClose: () {
            messenger?.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // Show an overlay SnackBar on top of all routes (including dialogs)
  static void showOverlay(
    BuildContext context, {
    required String message,
    NotificationType type = NotificationType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  })
  {
    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).padding.bottom + 24,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: SmartOverlayToast(
            message: message,
            type: type,
            actionLabel: actionLabel,
            onAction: onAction,
            duration: duration,
            onDismiss: () {
              try {
                overlayEntry.remove();
              } catch (_) {}
            },
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);
  }

  // Helper to get Color based on type
  static Color _getBgColor(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return AppColors.success;
      case NotificationType.error:
        return AppColors.error;
      case NotificationType.warning:
        return AppColors.warning;
      case NotificationType.info:
        return AppColors.info;
    }
  }

  // Helper to get Icon based on type
  static IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle_outline_rounded;
      case NotificationType.error:
        return Icons.error_outline;
      case NotificationType.warning:
        return Icons.warning_amber_rounded;
      case NotificationType.info:
        return Icons.info_outline;
    }
  }
}

/// A shared widget that provides the exact same UI layout, colors, and typography
/// for both standard and overlay snackbars.
class SmartSnackBarContentWidget extends StatelessWidget {
  final String message;
  final NotificationType type;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback onClose;

  const SmartSnackBarContentWidget({
    super.key,
    required this.message,
    required this.type,
    this.actionLabel,
    this.onAction,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = SmartSnackBars._getBgColor(type);
    final IconData iconData = SmartSnackBars._getIcon(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            color: AppColors.white,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onClose,
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class SmartOverlayToast extends StatefulWidget {
  final String message;
  final NotificationType type;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration duration;
  final VoidCallback onDismiss;

  const SmartOverlayToast({
    super.key,
    required this.message,
    required this.type,
    this.actionLabel,
    this.onAction,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<SmartOverlayToast> createState() => _SmartOverlayToastState();
}

class _SmartOverlayToastState extends State<SmartOverlayToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  Timer? _dismissTimer;
  bool _isDismissed = false;

  void _dismiss() {
    if (_isDismissed) return;
    _isDismissed = true;
    _dismissTimer?.cancel();
    if (mounted) {
      _controller.reverse().then((_) {
        widget.onDismiss();
      });
    } else {
      widget.onDismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    // Auto-dismiss after the duration (with animation fade out)
    final int durationMs = widget.duration.inMilliseconds;
    final int fadeOutDelay = durationMs > 300 ? durationMs - 250 : durationMs ~/ 2;
    _dismissTimer = Timer(Duration(milliseconds: fadeOutDelay), () {
      _dismiss();
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SmartSnackBarContentWidget(
          message: widget.message,
          type: widget.type,
          actionLabel: widget.actionLabel,
          onAction: widget.onAction != null
              ? () {
                  widget.onAction!();
                  _dismiss();
                }
              : null,
          onClose: _dismiss,
        ),
      ),
    );
  }
}

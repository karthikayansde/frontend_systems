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
        return AppColors.successGreen;
      case NotificationType.error:
        return AppColors.error;
      case NotificationType.warning:
        return AppColors.warning;
      case NotificationType.info:
        return AppColors.infoBlue;
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
    final int fadeOutDelay = widget.duration.inMilliseconds - 250;
    Future.delayed(
        Duration(milliseconds: fadeOutDelay > 0 ? fadeOutDelay : 2750), () {
      if (mounted) {
        _controller.reverse().then((_) {
          widget.onDismiss();
        });
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
                  _controller.reverse().then((_) {
                    widget.onDismiss();
                  });
                }
              : null,
          onClose: () {
            _controller.reverse().then((_) {
              widget.onDismiss();
            });
          },
        ),
      ),
    );
  }
}

// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // CRITICAL: Link the messenger key here
//       scaffoldMessengerKey: AppNotify.messengerKey,
//       title: 'Flutter Commonized App',
//       home: const HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Commonized Notifications'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // 1. Success Call
//             ElevatedButton.icon(
//               onPressed: () {
//                 AppNotify.show(
//                   message: "Profile updated successfully!",
//                   type: NotificationType.success,
//                 );
//               },
//               icon: const Icon(Icons.check),
//               label: const Text("Show Success"),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.green[100]),
//             ),
//             const SizedBox(height: 16),
//
//             // 2. Error Call
//             ElevatedButton.icon(
//               onPressed: () {
//                 AppNotify.show(
//                   message: "Failed to upload image. Please try again.",
//                   type: NotificationType.error,
//                 );
//               },
//               icon: const Icon(Icons.error),
//               label: const Text("Show Error"),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100]),
//             ),
//             const SizedBox(height: 16),
//
//             // 3. Warning Call with "Undo" Action
//             ElevatedButton.icon(
//               onPressed: () {
//                 AppNotify.show(
//                   message: "Item moved to trash.",
//                   type: NotificationType.warning,
//                   actionLabel: "UNDO",
//                   onAction: () {
//                     // Logic to restore item goes here
//                     debugPrint("User tapped Undo!");
//                   },
//                 );
//               },
//               icon: const Icon(Icons.warning),
//               label: const Text("Show Warning with Action"),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[100]),
//             ),
//             const SizedBox(height: 16),
//
//             // 4. Info Call
//             ElevatedButton.icon(
//               onPressed: () {
//                 AppNotify.show(
//                   actionLabel: "summa",
//                   message: "A new version of the app is available.",
//                   type: NotificationType.info,
//                 );
//               },
//               icon: const Icon(Icons.info),
//               label: const Text("Show Info"),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[100]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
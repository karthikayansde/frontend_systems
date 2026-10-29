import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frontend_systems/core/shared_widgets/smart_snack_bar.dart';

class SmartDialogs {
  // Global key to access navigator
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Get context from the global key
  static BuildContext? get _context => navigatorKey.currentContext;

  // Track if loading dialog is currently visible
  static bool _isLoadingShowing = false;

  // Show alert dialog
  static Future<void> showAlert({
    BuildContext? context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) async {
    final effectiveContext = context ?? _context;
    if (effectiveContext == null) return;

    return showDialog(
      context: effectiveContext,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }

  // Show custom dialog
  static Future<T?> showCustom<T>({
    BuildContext? context,
    required Widget Function(BuildContext context) builder,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) async {
    final effectiveContext = context ?? _context;
    if (effectiveContext == null) return null;

    return showDialog<T>(
      context: effectiveContext,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.25),
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: builder(ctx),
      ),
    );
  }

  // Show confirmation dialog
  static Future<bool?> showConfirmation({
    BuildContext? context,
    required String title,
    required String message,
    Color? buttonColor,
    String buttonText = 'OK',
    String cancelButtonText = 'Cancel',
  }) async {
    final effectiveContext = context ?? _context;
    if (effectiveContext == null) return null;

    return showDialog<bool>(
      context: effectiveContext,
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(cancelButtonText),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(buttonText, style: TextStyle(color: buttonColor)),
            ),
          ],
        ),
      ),
    );
  }

  static DateTime? _lastLoadingBackPress;

  // Show full-screen loading
  static void showLoading({
    BuildContext? context,
    String message = 'Please wait...',
    String backPressMessage = 'Please wait for the process to complete',
  }) {
    final effectiveContext = context ?? _context;
    if (effectiveContext == null || _isLoadingShowing) return;
    _isLoadingShowing = true;

    showDialog(
      context: effectiveContext,
      barrierDismissible: false, // Prevents closing by tapping outside
      barrierColor: Colors.black.withValues(alpha: 0.25),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: PopScope(
            canPop: false, // Prevents closing by back button
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;

              final now = DateTime.now();
              if (_lastLoadingBackPress == null || now.difference(_lastLoadingBackPress!) > const Duration(seconds: 2)) {
                _lastLoadingBackPress = now;
                SmartSnackBars.showOverlay(
                  ctx,
                  message: backPressMessage,
                  type: NotificationType.info,
                  duration: const Duration(seconds: 2),
                );
              }
            },
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      if (message.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          message,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      _isLoadingShowing = false;
    });
  }

  static void hideLoading([BuildContext? context]) {
    final effectiveContext = context ?? _context;
    if (effectiveContext == null || !_isLoadingShowing) return;
    _isLoadingShowing = false;
    Navigator.of(effectiveContext).pop();
  }
}

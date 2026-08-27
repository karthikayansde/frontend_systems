import 'package:flutter/material.dart';
import '../core/constants/app_spacings.dart';
import '../core/shared_widgets/smart_snack_bar.dart';
import '../core/shared_widgets/smart_dialogs.dart';

class SnackBarsScreen extends StatelessWidget {
  const SnackBarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Snack Bars Explorer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacings.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section Title
            _buildSectionHeader(context, 'Notification Showcase', Icons.notifications_active_outlined),
            const SizedBox(height: 16),

            // Card housing the controls (utilizing default cardTheme background)
            Card(
              elevation: 1,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacings.spacingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Trigger Controls',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tap the actions below to trigger dynamic, custom-styled system snack bar notifications (with or without action buttons).',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Success Section
                    _buildSubHeader(context, 'Success Notification'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTriggerButton(
                            context,
                            label: 'Show Success SnackBar',
                            icon: Icons.check_circle_outline_rounded,
                            color: const Color(0xFF2E7D32),
                            onPressed: () {
                              SmartSnackBars.show(
                                message: 'Profile updated successfully!',
                                type: NotificationType.success,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTriggerButton(
                            context,
                            label: 'Show Success SnackBar with Action',
                            icon: Icons.check_circle_outline_rounded,
                            color: const Color(0xFF2E7D32),
                            onPressed: () {
                              SmartSnackBars.show(
                                message: 'Profile updated successfully!',
                                type: NotificationType.success,
                                actionLabel: 'OK',
                                onAction: () {
                                  debugPrint('Success OK tapped!');
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Error Section
                    _buildSubHeader(context, 'Error Notification'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTriggerButton(
                            context,
                            label: 'Show Error SnackBar',
                            icon: Icons.error_outline_rounded,
                            color: const Color(0xFFD32F2F),
                            onPressed: () {
                              SmartSnackBars.show(
                                message: 'Failed to upload image. Please try again.',
                                type: NotificationType.error,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTriggerButton(
                            context,
                            label: 'Show Error SnackBar with Action',
                            icon: Icons.error_outline_rounded,
                            color: const Color(0xFFD32F2F),
                            onPressed: () {
                              SmartSnackBars.show(
                                message: 'Failed to upload image. Please try again.',
                                type: NotificationType.error,
                                actionLabel: 'RETRY',
                                onAction: () {
                                  debugPrint('Error RETRY tapped!');
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Warning Section
                    _buildSubHeader(context, 'Warning Notification'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTriggerButton(
                            context,
                            label: 'Show Warning SnackBar',
                            icon: Icons.warning_amber_rounded,
                            color: const Color(0xFFED6C02),
                            onPressed: () {
                              SmartSnackBars.show(
                                message: 'Item moved to trash.',
                                type: NotificationType.warning,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTriggerButton(
                            context,
                            label: 'Show Warning SnackBar with Action',
                            icon: Icons.warning_amber_rounded,
                            color: const Color(0xFFED6C02),
                            onPressed: () {
                              SmartSnackBars.show(
                                message: 'Item moved to trash.',
                                type: NotificationType.warning,
                                actionLabel: 'UNDO',
                                onAction: () {
                                  debugPrint('Warning UNDO tapped!');
                                  SmartSnackBars.show(
                                    message: 'Restored deleted item.',
                                    type: NotificationType.info,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Info Section
                    _buildSubHeader(context, 'Info Notification'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTriggerButton(
                            context,
                            label: 'Show Info SnackBar',
                            icon: Icons.info_outline_rounded,
                            color: const Color(0xFF0288D1),
                            onPressed: () {
                              SmartSnackBars.show(
                                message: 'A new version of the app is available.',
                                type: NotificationType.info,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTriggerButton(
                            context,
                            label: 'Show Info SnackBar with Action',
                            icon: Icons.info_outline_rounded,
                            color: const Color(0xFF0288D1),
                            onPressed: () {
                              SmartSnackBars.show(
                                message: 'A new version of the app is available.',
                                type: NotificationType.info,
                                actionLabel: 'DISMISS',
                                onAction: () {
                                  debugPrint('Info DISMISS tapped!');
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Dialog Overlay Demonstration Card
            _buildSectionHeader(context, 'Overlay Demonstration', Icons.layers_outlined),
            const SizedBox(height: 16),
            Card(
              elevation: 1,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacings.spacingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Dialog Overlay Demonstration',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Compare standard snack bars (shown behind dialogs) with overlay snack bars (shown on top of active dialogs).',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primaryContainer,
                        foregroundColor: colorScheme.onPrimaryContainer,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        _showOverlayDialog();
                      },
                      icon: const Icon(Icons.picture_in_picture_alt_rounded),
                      label: const Text(
                        'Open Overlay Demonstration Dialog',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Divider(thickness: 1.2),
      ],
    );
  }

  Widget _buildSubHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTriggerButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        side: BorderSide(color: color.withValues(alpha: 0.5), width: 1.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showOverlayDialog() {
    SmartDialogs.showCustom(
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        final colorScheme = theme.colorScheme;
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.layers_outlined, color: colorScheme.primary),
              const SizedBox(width: 8),
              const Text('Overlay Dialog Demo'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'This dialog lets you compare how Normal and Overlay SnackBars render.\n\n'
                '• Normal SnackBars display behind this dialog (hidden).\n'
                '• Overlay SnackBars display on top of this dialog (visible).',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        SmartSnackBars.show(
                          message: 'This is a normal SnackBar shown behind the dialog.',
                          type: NotificationType.info,
                        );
                      },
                      child: Text(
                        'Normal SnackBar',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.secondary,
                        foregroundColor: colorScheme.onSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        SmartSnackBars.showOverlay(
                          dialogContext,
                          message: 'This is an overlay SnackBar shown on top of the dialog.',
                          type: NotificationType.success,
                        );
                      },
                      child: Text(
                        'Overlay SnackBar',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../core/constants/app_spacings.dart';
import '../core/shared_widgets/smart_dialogs.dart';
import '../core/shared_widgets/smart_snack_bar.dart';

class DialogsScreen extends StatelessWidget {
  const DialogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialogs & Popups Explorer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacings.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section Title
            _buildSectionHeader(context, 'Dialog Showcase', Icons.widgets_outlined),
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
                      'Common Dialog Triggers',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Trigger pre-styled overlay dialogs, loaders, confirmation prompts, and custom layouts.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),

                    // 1. Alert Dialog
                    _buildTriggerButton(
                      context,
                      label: 'Open Sample Dialog',
                      icon: Icons.info_outline_rounded,
                      color: colorScheme.primary,
                      onPressed: () {
                        SmartDialogs.showAlert(
                          title: 'Sample Dialog',
                          message: 'This is a sample alert dialog.',
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // 2. Loading Dialog
                    _buildTriggerButton(
                      context,
                      label: 'Show Smart Loading (4s Auto-Dismiss)',
                      icon: Icons.hourglass_empty_rounded,
                      color: Colors.teal,
                      onPressed: () {
                        SmartDialogs.showLoading();
                        Future.delayed(const Duration(seconds: 4), () {
                          SmartDialogs.hideLoading();
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // 3. Confirmation Dialog
                    _buildTriggerButton(
                      context,
                      label: 'Show Confirmation Dialog',
                      icon: Icons.help_outline_rounded,
                      color: Colors.indigo,
                      onPressed: () async {
                        final confirmed = await SmartDialogs.showConfirmation(
                          title: 'Confirm Action',
                          message: 'Are you sure you want to perform this action? This operation cannot be undone.',
                          buttonText: 'Confirm',
                          cancelButtonText: 'Cancel',
                        );
                        if (confirmed != null) {
                          SmartSnackBars.show(
                            message: confirmed ? 'Action confirmed!' : 'Action cancelled.',
                            type: confirmed ? NotificationType.success : NotificationType.info,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // 4. Custom Dialog
                    _buildTriggerButton(
                      context,
                      label: 'Show Custom Dialog',
                      icon: Icons.dashboard_customize_outlined,
                      color: Colors.deepPurple,
                      onPressed: () {
                        SmartDialogs.showCustom(
                          builder: (dialogContext) {
                            final localTheme = Theme.of(dialogContext);
                            final localScheme = localTheme.colorScheme;
                            return AlertDialog(
                              title: Row(
                                children: [
                                  Icon(Icons.stars_rounded, color: localScheme.primary),
                                  const SizedBox(width: 8),
                                  const Text('Premium Feature'),
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'This is a completely custom modal layout rendered inside the SmartDialogs wrapper.',
                                    style: localTheme.textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: localScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.lock_open_rounded, color: localScheme.onPrimaryContainer),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Custom widgets, rows, and containers are supported.',
                                            style: localTheme.textTheme.bodySmall?.copyWith(
                                              color: localScheme.onPrimaryContainer,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: const Text('Got it!'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Design specs / documentation section
            _buildSectionHeader(context, 'Dialog Specifications', Icons.bookmark_border_rounded),
            const SizedBox(height: 16),
            _buildSpecTable(context),
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

  Widget _buildTriggerButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: BorderSide(color: color.withValues(alpha: 0.5), width: 1.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: color, size: 20),
      label: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSpecTable(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSpecRow(context, 'Dialog State', 'Layer Behavior', 'Intended Usage'),
            const Divider(),
            _buildSpecRow(context, 'Alert', 'Modal / Dismissible', 'Information alerts, validations, prompts.'),
            _buildSpecRow(context, 'Confirmation', 'Modal / Decision', 'Confirming destructive or major operations.'),
            _buildSpecRow(context, 'Loading', 'Full Blocker / Pop Blocked', 'Long processes (disables double-back).'),
            _buildSpecRow(context, 'Custom', 'Modular / Configurable', 'Rich forms, features, and complex UI modals.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(BuildContext context, String col1, String col2, String col3) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              col1,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              col2,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              col3,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

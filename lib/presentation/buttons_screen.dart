import 'package:flutter/material.dart';
import '../core/constants/app_spacings.dart';
import '../core/shared_widgets/smart_form_fields/smart_buttons.dart';

class ButtonsScreen extends StatelessWidget {
  const ButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buttons Explorer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacings.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. SmartPrimaryButton (Filled) Card
            _buildSectionHeader(context, 'Smart Primary Buttons (Filled)', Icons.smart_button_rounded),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacings.spacingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Default Filled Style',
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.hintColor),
                    ),
                    const SizedBox(height: 8),
                    SmartPrimaryButton(
                      label: 'Primary Button',
                      onPressed: () async {
                        debugPrint('Primary Button pressed');
                      },
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Disabled Style (isDisable = true)',
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.hintColor),
                    ),
                    const SizedBox(height: 8),
                    SmartPrimaryButton(
                      label: 'Disabled Button',
                      isDisable: true,
                      onPressed: () async {},
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Parent Controlled Loading (isLoading = true)',
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.hintColor),
                    ),
                    const SizedBox(height: 8),
                    SmartPrimaryButton(
                      label: 'Parent Loading',
                      isLoading: true,
                      onPressed: () async {},
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Internal Auto-Loading (autoLoading = true, simulates 2s work)',
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.hintColor),
                    ),
                    const SizedBox(height: 8),
                    SmartPrimaryButton(
                      label: 'Auto Loading Button',
                      autoLoading: true,
                      onPressed: () async {
                        await Future.delayed(const Duration(seconds: 2));
                      },
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Button with Icon',
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.hintColor),
                    ),
                    const SizedBox(height: 8),
                    SmartPrimaryButton(
                      label: 'Send Message',
                      icon: Icons.send_rounded,
                      onPressed: () async {
                        debugPrint('Send Message pressed');
                      },
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Custom Background Color',
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.hintColor),
                    ),
                    const SizedBox(height: 8),
                    SmartPrimaryButton(
                      label: 'Delete Asset',
                      backgroundColor: colorScheme.error,
                      icon: Icons.delete_forever_rounded,
                      onPressed: () async {
                        debugPrint('Delete Asset pressed');
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. SmartPrimaryButton (Outlined) Card
            _buildSectionHeader(context, 'Smart Primary Buttons (Outlined)', Icons.radio_button_unchecked_rounded),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacings.spacingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Default Outlined Style',
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.hintColor),
                    ),
                    const SizedBox(height: 8),
                    SmartPrimaryButton(
                      label: 'Outlined Button',
                      isOutlined: true,
                      onPressed: () async {
                        debugPrint('Outlined Button pressed');
                      },
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Disabled Outlined',
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.hintColor),
                    ),
                    const SizedBox(height: 8),
                    SmartPrimaryButton(
                      label: 'Disabled Outlined',
                      isOutlined: true,
                      isDisable: true,
                      onPressed: () async {},
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Auto-Loading Outlined',
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.hintColor),
                    ),
                    const SizedBox(height: 8),
                    SmartPrimaryButton(
                      label: 'Loading Outlined',
                      isOutlined: true,
                      autoLoading: true,
                      onPressed: () async {
                        await Future.delayed(const Duration(seconds: 2));
                      },
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Outlined with Icon',
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.hintColor),
                    ),
                    const SizedBox(height: 8),
                    SmartPrimaryButton(
                      label: 'Add Item',
                      isOutlined: true,
                      icon: Icons.add_circle_outline_rounded,
                      onPressed: () async {
                        debugPrint('Add Item pressed');
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // SmartPrimaryButton (Text) Card
            _buildSectionHeader(context, 'Smart Primary Buttons (Text)', Icons.text_fields_rounded),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacings.spacingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Default Text Style (isText = true)',
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.hintColor),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SmartPrimaryButton(
                        label: 'Text Button',
                        isText: true,
                        onPressed: () async {
                          debugPrint('Text Button pressed');
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Disabled Text Button',
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.hintColor),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SmartPrimaryButton(
                        label: 'Disabled Text',
                        isText: true,
                        isDisable: true,
                        onPressed: () async {},
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Auto-Loading Text Button (simulates 2s work)',
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.hintColor),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SmartPrimaryButton(
                        label: 'Loading Text',
                        isText: true,
                        autoLoading: true,
                        onPressed: () async {
                          await Future.delayed(const Duration(seconds: 2));
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Text Button with Icon',
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.hintColor),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SmartPrimaryButton(
                        label: 'Text with Icon',
                        isText: true,
                        icon: Icons.info_outline_rounded,
                        onPressed: () async {
                          debugPrint('Text with Icon pressed');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 3. StyledIconButton Card
            _buildSectionHeader(context, 'Styled Icon Buttons', Icons.emoji_emotions_outlined),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacings.spacingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Displays standard square icon buttons, with or without outline variants.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        Column(
                          children: [
                            StyledIconButton(
                              icon: Icons.settings_rounded,
                              onPressed: () {
                                debugPrint('Settings icon button pressed');
                              },
                            ),
                            const SizedBox(height: 6),
                            Text('Standard', style: theme.textTheme.labelSmall),
                          ],
                        ),
                        Column(
                          children: [
                            StyledIconButton(
                              icon: Icons.home_rounded,
                              isOutlined: true,
                              onPressed: () {
                                debugPrint('Home icon button pressed');
                              },
                            ),
                            const SizedBox(height: 6),
                            Text('Outlined', style: theme.textTheme.labelSmall),
                          ],
                        ),
                        Column(
                          children: [
                            StyledIconButton(
                              icon: Icons.notifications_rounded,
                              buttonSize: 56,
                              iconSize: 28,
                              onPressed: () {
                                debugPrint('Notification icon button pressed');
                              },
                            ),
                            const SizedBox(height: 6),
                            Text('Large Size', style: theme.textTheme.labelSmall),
                          ],
                        ),
                        Column(
                          children: [
                            StyledIconButton(
                              icon: Icons.favorite_rounded,
                              backgroundColor: colorScheme.primaryContainer,
                              iconColor: colorScheme.onPrimaryContainer,
                              onPressed: () {
                                debugPrint('Favorite icon button pressed');
                              },
                            ),
                            const SizedBox(height: 6),
                            Text('Filled BG', style: theme.textTheme.labelSmall),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 4. SmartFAB Card
            _buildSectionHeader(context, 'Smart Floating Action Buttons', Icons.add_to_photos_rounded),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacings.spacingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Standard FAB wrapper that inherits the design theme.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SmartFAB(
                          heroTag: 'demo_fab',
                          onPressed: () {
                            debugPrint('FAB pressed');
                          },
                          child: const Icon(Icons.add_rounded),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'SmartFAB Widget',
                          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
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
}

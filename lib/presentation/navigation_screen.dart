import 'package:flutter/material.dart';
import '../core/constants/app_spacings.dart';
import '../core/shared_services/navigation_service.dart';
import '../core/shared_widgets/smart_form_fields/smart_buttons.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Transition Explorer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacings.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Slide Card
            _buildSectionHeader(context, 'Directional Slide Transitions', Icons.swap_calls_rounded),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacings.spacingLarge),
                child: Column(
                  children: [
                    _buildTransitionRow(
                      context,
                      title: 'Slide from Right',
                      description: 'Standard push transition moving horizontally from right to left.',
                      type: SmartTransitionType.slideRight,
                    ),
                    const Divider(height: 24),
                    _buildTransitionRow(
                      context,
                      title: 'Slide from Left',
                      description: 'Reverse push transition moving horizontally from left to right.',
                      type: SmartTransitionType.slideLeft,
                    ),
                    const Divider(height: 24),
                    _buildTransitionRow(
                      context,
                      title: 'Slide from Bottom',
                      description: 'Modal-style push transition moving vertically from bottom to top.',
                      type: SmartTransitionType.slideBottom,
                    ),
                    const Divider(height: 24),
                    _buildTransitionRow(
                      context,
                      title: 'Slide from Top',
                      description: 'Dropdown-style transition moving vertically from top to bottom.',
                      type: SmartTransitionType.slideTop,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Fade & Scale Card
            _buildSectionHeader(context, 'Scale & Opacity Transitions', Icons.blur_on_rounded),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacings.spacingLarge),
                child: Column(
                  children: [
                    _buildTransitionRow(
                      context,
                      title: 'Cross Fade',
                      description: 'Smooth transparency cross-fade between active screens.',
                      type: SmartTransitionType.fade,
                    ),
                    const Divider(height: 24),
                    _buildTransitionRow(
                      context,
                      title: 'Scale Reveal',
                      description: 'Grows the destination page outwards from the center of the viewport.',
                      type: SmartTransitionType.scale,
                    ),
                    const Divider(height: 24),
                    _buildTransitionRow(
                      context,
                      title: 'Scale & Fade (Combined)',
                      description: 'Blends a subtle zoom reveal with a simultaneous opacity fade.',
                      type: SmartTransitionType.scaleFade,
                    ),
                    const Divider(height: 24),
                    _buildTransitionRow(
                      context,
                      title: 'iOS Card-Stack Style',
                      description: 'iOS-like navigation that slides up and scales from 92% with a fade.',
                      type: SmartTransitionType.iosCardStack,
                    ),
                    const Divider(height: 24),
                    _buildTransitionRow(
                      context,
                      title: 'Material Z-Axis Zoom',
                      description: 'Forward zoom-out effect blended with an opacity fade entry.',
                      type: SmartTransitionType.zAxisZoom,
                    ),
                    const Divider(height: 24),
                    _buildTransitionRow(
                      context,
                      title: 'Rotate & Fade',
                      description: 'Slight spin rotation and simultaneous opacity fade reveal.',
                      type: SmartTransitionType.rotateFade,
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

  Widget _buildTransitionRow(
    BuildContext context, {
    required String title,
    required String description,
    required SmartTransitionType type,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SmartPrimaryButton(
              label: 'Test',
              width: 90,
              onPressed: () async {
                await SmartNavigation.push(
                  context,
                  DummyNavigationPage(transitionTitle: title, transitionType: type),
                  transition: type,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class DummyNavigationPage extends StatelessWidget {
  final String transitionTitle;
  final SmartTransitionType transitionType;

  const DummyNavigationPage({
    super.key,
    required this.transitionTitle,
    required this.transitionType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.7),
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacings.spacingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                const Text(
                  '🚀',
                  style: TextStyle(fontSize: 80),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  'Dummy Page Reached',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Arrived via custom transition:\n"$transitionTitle"',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Transition Enum Value:',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$transitionType',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                SmartPrimaryButton(
                  label: 'Go Back',
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

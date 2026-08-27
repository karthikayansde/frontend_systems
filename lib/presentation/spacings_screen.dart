import 'package:flutter/material.dart';
import '../core/constants/app_spacings.dart';

class SpacingsScreen extends StatelessWidget {
  const SpacingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spacings & Tokens'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacings.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Spacings Section
            _buildSectionHeader(context, 'Spacings', Icons.space_bar_rounded),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacings.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSpacingItem(context, 'spaceXxs', AppSpacings.spaceXxs),
                    _buildSpacingItem(context, 'spaceXs', AppSpacings.spaceXs),
                    _buildSpacingItem(context, 'spaceSm', AppSpacings.spaceSm),
                    _buildSpacingItem(context, 'spaceMd', AppSpacings.spaceMd),
                    _buildSpacingItem(context, 'spaceLg', AppSpacings.spaceLg),
                    _buildSpacingItem(context, 'spaceXl', AppSpacings.spaceXl),
                    _buildSpacingItem(context, 'spaceXxl', AppSpacings.spaceXxl),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Icon Sizes Section
            _buildSectionHeader(context, 'Icon Sizes', Icons.crop_free_rounded),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacings.spaceMd),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    _buildIconSizeItem(context, 'iconSmall', AppSpacings.iconSmall),
                    _buildIconSizeItem(context, 'iconMedium', AppSpacings.iconMedium),
                    _buildIconSizeItem(context, 'iconLarge', AppSpacings.iconLarge),
                    _buildIconSizeItem(context, 'iconExtraLarge', AppSpacings.iconExtraLarge),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 3. Border Radii Section
            _buildSectionHeader(context, 'Border Radii', Icons.rounded_corner_rounded),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacings.spaceMd),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    _buildRadiusItem(context, 'radiusSm', AppSpacings.radiusSm),
                    _buildRadiusItem(context, 'radiusMd', AppSpacings.radiusMd),
                    _buildRadiusItem(context, 'radiusLg', AppSpacings.radiusLg),
                    _buildRadiusItem(context, 'radiusXl', AppSpacings.radiusXl),
                    _buildRadiusItem(context, 'radiusPill', AppSpacings.radiusPill, isPill: true),
                    _buildRadiusItem(context, 'radiusCircle', AppSpacings.radiusCircle, isCircle: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 4. Elevations Section
            _buildSectionHeader(context, 'Elevations & Shadows', Icons.layers_rounded),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacings.spaceMd),
                child: Column(
                  children: [
                    _buildElevationItem(context, 'elevationNone', AppSpacings.elevationNone),
                    const SizedBox(height: 16),
                    _buildElevationItem(context, 'elevationLow', AppSpacings.elevationLow),
                    const SizedBox(height: 16),
                    _buildElevationItem(context, 'elevationMedium', AppSpacings.elevationMedium),
                    const SizedBox(height: 16),
                    _buildElevationItem(context, 'elevationHigh', AppSpacings.elevationHigh),
                    const SizedBox(height: 16),
                    _buildElevationItem(context, 'elevationExtraHigh', AppSpacings.elevationExtraHigh),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 5. Image & Zoom Section
            _buildSectionHeader(context, 'Token Visualization Diagram', Icons.image_search_rounded),
            const SizedBox(height: 12),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacings.spaceMd),
                    child: Text(
                      'Pinch or drag to zoom and explore the layout tokens visualization diagram.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ),
                  Container(
                    height: 350,
                    color: colorScheme.surfaceContainerLow,
                    child: InteractiveViewer(
                      clipBehavior: Clip.hardEdge,
                      maxScale: 5.0,
                      minScale: 1.0,
                      child: Image.asset(
                        'assets/img.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
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

  Widget _buildSpacingItem(BuildContext context, String name, double value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${value.toStringAsFixed(1)}px',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontFamily: 'monospace',
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Horizontal bar representing the height of the spacing
          Container(
            height: value,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconSizeItem(BuildContext context, String name, double size) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Square box of the exact icon size
        Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            border: Border.all(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.star_rounded,
            size: size,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          '${size.toStringAsFixed(1)}px',
          style: theme.textTheme.labelSmall?.copyWith(
            fontFamily: 'monospace',
            color: theme.hintColor,
            fontSize: 9.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRadiusItem(BuildContext context, String name, double radius, {bool isPill = false, bool isCircle = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use responsive square sizing for preview
    double width = 64;
    double height = 64;
    if (isPill) {
      width = 90;
      height = 40;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(radius),
          ),
          alignment: Alignment.center,
          child: Text(
            '${radius > 1000 ? "50%" : radius.toStringAsFixed(0)}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          radius > 1000 ? 'Circle' : '${radius.toStringAsFixed(1)}px',
          style: theme.textTheme.labelSmall?.copyWith(
            fontFamily: 'monospace',
            color: theme.hintColor,
            fontSize: 9.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildElevationItem(BuildContext context, String name, double value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        boxShadow: value > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: value * 1.5,
                  spreadRadius: value * 0.2,
                  offset: Offset(0, value * 0.5),
                ),
              ]
            : null,
        border: value == 0
            ? Border.all(color: colorScheme.outlineVariant,width: .5)
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Elevation ${value.toStringAsFixed(1)}',
            style: theme.textTheme.labelMedium?.copyWith(
              fontFamily: 'monospace',
              color: theme.hintColor,
            ),
          ),
        ],
      ),
    );
  }
}

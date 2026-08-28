import 'package:flutter/material.dart';
import '../core/constants/app_spacings.dart';

class TypographyScreen extends StatelessWidget {
  const TypographyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Define all 15 standard Material 3 text theme styles
    final displayStyles = [
      _TextStyleInfo('displayLarge', textTheme.displayLarge ?? const TextStyle()),
      _TextStyleInfo('displayMedium', textTheme.displayMedium ?? const TextStyle()),
      _TextStyleInfo('displaySmall', textTheme.displaySmall ?? const TextStyle()),
    ];

    final headlineStyles = [
      _TextStyleInfo('headlineLarge', textTheme.headlineLarge ?? const TextStyle()),
      _TextStyleInfo('headlineMedium', textTheme.headlineMedium ?? const TextStyle()),
      _TextStyleInfo('headlineSmall', textTheme.headlineSmall ?? const TextStyle()),
    ];

    final titleStyles = [
      _TextStyleInfo('titleLarge', textTheme.titleLarge ?? const TextStyle()),
      _TextStyleInfo('titleMedium', textTheme.titleMedium ?? const TextStyle()),
      _TextStyleInfo('titleSmall', textTheme.titleSmall ?? const TextStyle()),
    ];

    final bodyStyles = [
      _TextStyleInfo('bodyLarge', textTheme.bodyLarge ?? const TextStyle()),
      _TextStyleInfo('bodyMedium', textTheme.bodyMedium ?? const TextStyle()),
      _TextStyleInfo('bodySmall', textTheme.bodySmall ?? const TextStyle()),
    ];

    final labelStyles = [
      _TextStyleInfo('labelLarge', textTheme.labelLarge ?? const TextStyle()),
      _TextStyleInfo('labelMedium', textTheme.labelMedium ?? const TextStyle()),
      _TextStyleInfo('labelSmall', textTheme.labelSmall ?? const TextStyle()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Typography System Explorer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacings.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFontFamilyHeader(context),
            const SizedBox(height: 24),

            _buildSectionHeader(context, 'Display Styles', Icons.font_download_outlined),
            const SizedBox(height: 12),
            _buildTextStyleList(displayStyles),
            const SizedBox(height: 32),

            _buildSectionHeader(context, 'Headline Styles', Icons.text_fields_outlined),
            const SizedBox(height: 12),
            _buildTextStyleList(headlineStyles),
            const SizedBox(height: 32),

            _buildSectionHeader(context, 'Title Styles', Icons.title_rounded),
            const SizedBox(height: 12),
            _buildTextStyleList(titleStyles),
            const SizedBox(height: 32),

            _buildSectionHeader(context, 'Body Styles', Icons.subject_rounded),
            const SizedBox(height: 12),
            _buildTextStyleList(bodyStyles),
            const SizedBox(height: 32),

            _buildSectionHeader(context, 'Label Styles', Icons.label_outline_rounded),
            const SizedBox(height: 12),
            _buildTextStyleList(labelStyles),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFontFamilyHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.text_format_rounded, color: colorScheme.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                'Brand Typography Info',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• Headings & Displays (Brand Font): Satoshi\n'
            '• Body Text & Small Labels (Body Font): PlusJakartaSans\n'
            '• Default Fallback: System Default / Monospace',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
          ),
        ],
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

  Widget _buildTextStyleList(List<_TextStyleInfo> styles) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: styles.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final info = styles[index];
        return _TextThemeRow(
          name: info.name,
          style: info.style,
        );
      },
    );
  }
}

class _TextStyleInfo {
  final String name;
  final TextStyle style;
  _TextStyleInfo(this.name, this.style);
}

class _TextThemeRow extends StatelessWidget {
  final String name;
  final TextStyle style;

  const _TextThemeRow({
    required this.name,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Extract metadata
    final fontFamily = style.fontFamily ?? 'Default';
    final fontSize = style.fontSize?.toStringAsFixed(0) ?? 'N/A';
    final fontWeight = _getWeightLabel(style.fontWeight);
    final letterSpacing = style.letterSpacing?.toStringAsFixed(2) ?? '0.00';
    final height = style.height?.toStringAsFixed(2) ?? '1.00';

    final details = '$fontFamily • ${fontSize}px • $fontWeight\nls: $letterSpacing • lh: $height';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                Tooltip(
                  message: 'Font Details:\n$details',
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      '$fontFamily • ${fontSize}px • $fontWeight',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontFamily: 'monospace',
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Ag 1234567890 - Rapid font preview',
              style: style.copyWith(
                color: colorScheme.onSurface,
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getWeightLabel(FontWeight? weight) {
    if (weight == FontWeight.w100) return 'w100';
    if (weight == FontWeight.w200) return 'w200';
    if (weight == FontWeight.w300) return 'w300';
    if (weight == FontWeight.w400) return 'w400';
    if (weight == FontWeight.w500) return 'w500';
    if (weight == FontWeight.w600) return 'w600';
    if (weight == FontWeight.w700) return 'w700';
    if (weight == FontWeight.w800) return 'w800';
    if (weight == FontWeight.w900) return 'w900';
    return 'w400';
  }
}

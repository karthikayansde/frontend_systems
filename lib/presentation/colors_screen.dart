import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacings.dart';
import '../core/theme/app_color_schemes.dart';
import '../core/theme/app_text_theme.dart';

class ColorsScreen extends StatelessWidget {
  const ColorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 1. Raw Constant Colors from AppColors file (as requested)
    final appColorsMap = {
      'white': AppColors.white,
      'black': AppColors.black,
      'transparent': AppColors.transparent,
      'success': AppColors.success,
      'warning': AppColors.warning,
      'error': AppColors.error,
      'info': AppColors.info,
      'seed': AppColors.seed,
    };

    // Instantiate Light and Dark ThemeData using the project's config
    final lightThemeData = AppColorSchemes(AppTextTheme.textTheme).light;
    final darkThemeData = AppColorSchemes(AppTextTheme.textTheme).dark;

    // Define the side-by-side color resolvers for each section
    final brandResolvers = [
      _ColorResolver('primary', (scheme, ext) => scheme.primary),
      _ColorResolver('primaryLight', (scheme, ext) => scheme.primaryContainer),
      _ColorResolver('primaryDark', (scheme, ext) => scheme.onPrimaryContainer),
      _ColorResolver('secondary', (scheme, ext) => scheme.secondary),
      _ColorResolver('secondaryLight', (scheme, ext) => scheme.secondaryContainer),
      _ColorResolver('secondaryDark', (scheme, ext) => scheme.onSecondaryContainer),
      _ColorResolver('tertiary', (scheme, ext) => scheme.tertiary),
      _ColorResolver('tertiaryLight', (scheme, ext) => scheme.tertiaryContainer),
      _ColorResolver('tertiaryDark', (scheme, ext) => scheme.onTertiaryContainer),
    ];

    final semanticResolvers = [
      _ColorResolver('success', (scheme, ext) => ext?.success ?? Colors.green),
      _ColorResolver('warning', (scheme, ext) => ext?.warning ?? Colors.orange),
      _ColorResolver('error', (scheme, ext) => scheme.error),
      _ColorResolver('info', (scheme, ext) => ext?.info ?? Colors.blue),
    ];

    final neutralResolvers = [
      _ColorResolver('background', (scheme, ext) => scheme.surface),
      _ColorResolver('surface', (scheme, ext) => scheme.surface),
      _ColorResolver('surfaceVariant', (scheme, ext) => scheme.surfaceVariant),
      _ColorResolver('outline', (scheme, ext) => scheme.outline),
      _ColorResolver('disabled', (scheme, ext) => scheme.onSurface.withValues(alpha: 0.38)),
    ];

    final textResolvers = [
      _ColorResolver('textPrimary', (scheme, ext) => scheme.onSurface),
      _ColorResolver('textSecondary', (scheme, ext) => scheme.onSurfaceVariant),
      _ColorResolver('onPrimary', (scheme, ext) => scheme.onPrimary),
      _ColorResolver('onError', (scheme, ext) => scheme.onError),
      _ColorResolver('linkColor', (scheme, ext) => scheme.primary),
    ];

    // Define all 45 standard Material 3 ColorScheme property resolvers
    final colorSchemeResolvers = [
      _ColorSchemeResolver('primary', (scheme) => scheme.primary),
      _ColorSchemeResolver('onPrimary', (scheme) => scheme.onPrimary),
      _ColorSchemeResolver('primaryContainer', (scheme) => scheme.primaryContainer),
      _ColorSchemeResolver('onPrimaryContainer', (scheme) => scheme.onPrimaryContainer),
      _ColorSchemeResolver('secondary', (scheme) => scheme.secondary),
      _ColorSchemeResolver('onSecondary', (scheme) => scheme.onSecondary),
      _ColorSchemeResolver('secondaryContainer', (scheme) => scheme.secondaryContainer),
      _ColorSchemeResolver('onSecondaryContainer', (scheme) => scheme.onSecondaryContainer),
      _ColorSchemeResolver('tertiary', (scheme) => scheme.tertiary),
      _ColorSchemeResolver('onTertiary', (scheme) => scheme.onTertiary),
      _ColorSchemeResolver('tertiaryContainer', (scheme) => scheme.tertiaryContainer),
      _ColorSchemeResolver('onTertiaryContainer', (scheme) => scheme.onTertiaryContainer),
      _ColorSchemeResolver('error', (scheme) => scheme.error),
      _ColorSchemeResolver('onError', (scheme) => scheme.onError),
      _ColorSchemeResolver('errorContainer', (scheme) => scheme.errorContainer),
      _ColorSchemeResolver('onErrorContainer', (scheme) => scheme.onErrorContainer),
      _ColorSchemeResolver('surface', (scheme) => scheme.surface),
      _ColorSchemeResolver('onSurface', (scheme) => scheme.onSurface),
      _ColorSchemeResolver('surfaceVariant', (scheme) => scheme.surfaceVariant),
      _ColorSchemeResolver('onSurfaceVariant', (scheme) => scheme.onSurfaceVariant),
      _ColorSchemeResolver('outline', (scheme) => scheme.outline),
      _ColorSchemeResolver('outlineVariant', (scheme) => scheme.outlineVariant),
      _ColorSchemeResolver('shadow', (scheme) => scheme.shadow),
      _ColorSchemeResolver('scrim', (scheme) => scheme.scrim),
      _ColorSchemeResolver('inverseSurface', (scheme) => scheme.inverseSurface),
      _ColorSchemeResolver('onInverseSurface', (scheme) => scheme.onInverseSurface),
      _ColorSchemeResolver('inversePrimary', (scheme) => scheme.inversePrimary),
      _ColorSchemeResolver('surfaceTint', (scheme) => scheme.surfaceTint),
      _ColorSchemeResolver('surfaceDim', (scheme) => scheme.surfaceDim),
      _ColorSchemeResolver('surfaceBright', (scheme) => scheme.surfaceBright),
      _ColorSchemeResolver('surfaceContainerLowest', (scheme) => scheme.surfaceContainerLowest),
      _ColorSchemeResolver('surfaceContainerLow', (scheme) => scheme.surfaceContainerLow),
      _ColorSchemeResolver('surfaceContainer', (scheme) => scheme.surfaceContainer),
      _ColorSchemeResolver('surfaceContainerHigh', (scheme) => scheme.surfaceContainerHigh),
      _ColorSchemeResolver('surfaceContainerHighest', (scheme) => scheme.surfaceContainerHighest),
      _ColorSchemeResolver('primaryFixed', (scheme) => scheme.primaryFixed),
      _ColorSchemeResolver('primaryFixedDim', (scheme) => scheme.primaryFixedDim),
      _ColorSchemeResolver('onPrimaryFixed', (scheme) => scheme.onPrimaryFixed),
      _ColorSchemeResolver('onPrimaryFixedVariant', (scheme) => scheme.onPrimaryFixedVariant),
      _ColorSchemeResolver('secondaryFixed', (scheme) => scheme.secondaryFixed),
      _ColorSchemeResolver('secondaryFixedDim', (scheme) => scheme.secondaryFixedDim),
      _ColorSchemeResolver('onSecondaryFixed', (scheme) => scheme.onSecondaryFixed),
      _ColorSchemeResolver('onSecondaryFixedVariant', (scheme) => scheme.onSecondaryFixedVariant),
      _ColorSchemeResolver('tertiaryFixed', (scheme) => scheme.tertiaryFixed),
      _ColorSchemeResolver('tertiaryFixedDim', (scheme) => scheme.tertiaryFixedDim),
      _ColorSchemeResolver('onTertiaryFixed', (scheme) => scheme.onTertiaryFixed),
      _ColorSchemeResolver('onTertiaryFixedVariant', (scheme) => scheme.onTertiaryFixedVariant),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Colors System Explorer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacings.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section 1: AppColors File Constants
            _buildSectionHeader(context, 'App Colors (Constant Values)', Icons.save_outlined),
            const SizedBox(height: 12),
            _buildConstantsGrid(appColorsMap),
            const SizedBox(height: 32),

            // Section 2: Token Groups displaying Light & Dark side-by-side
            _buildSectionHeader(context, 'Brand Colors', Icons.stars_outlined),
            const SizedBox(height: 8),
            _buildTokenRowsList(brandResolvers, lightThemeData, darkThemeData),
            const SizedBox(height: 32),

            _buildSectionHeader(context, 'Semantic Colors', Icons.warning_amber_rounded),
            const SizedBox(height: 8),
            _buildTokenRowsList(semanticResolvers, lightThemeData, darkThemeData),
            const SizedBox(height: 32),

            _buildSectionHeader(context, 'Neutral Scale', Icons.blur_linear_outlined),
            const SizedBox(height: 8),
            _buildTokenRowsList(neutralResolvers, lightThemeData, darkThemeData),
            const SizedBox(height: 32),

            _buildSectionHeader(context, 'Text Colors', Icons.text_fields_rounded),
            const SizedBox(height: 8),
            _buildTokenRowsList(textResolvers, lightThemeData, darkThemeData),
            const SizedBox(height: 32),

            // Section 3: ColorScheme Theme Colors (Light & Dark side-by-side comparison)
            _buildSectionHeader(context, 'Theme ColorScheme (All Colors Comparison)', Icons.brightness_medium_rounded),
            const SizedBox(height: 8),
            _buildColorSchemeRowsList(colorSchemeResolvers, lightThemeData, darkThemeData),
            const SizedBox(height: 16),
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
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Divider(thickness: 1.2),
      ],
    );
  }

  Widget _buildConstantsGrid(Map<String, Color> colorMap) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: colorMap.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemBuilder: (context, index) {
            final key = colorMap.keys.elementAt(index);
            final color = colorMap[key]!;
            final isLight = color.computeLuminance() > 0.5;
            final textColor = isLight ? Colors.black : Colors.white;

            return Container(
              padding: const EdgeInsets.all(AppSpacings.spacingMedium),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      key,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.7),
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTokenRowsList(List<_ColorResolver> resolvers, ThemeData lightTheme, ThemeData darkTheme) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: resolvers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final resolver = resolvers[index];
        return _TokenRow(
          tokenName: resolver.name,
          colorResolver: resolver.resolver,
          lightTheme: lightTheme,
          darkTheme: darkTheme,
        );
      },
    );
  }

  Widget _buildColorSchemeRowsList(List<_ColorSchemeResolver> resolvers, ThemeData lightTheme, ThemeData darkTheme) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: resolvers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final resolver = resolvers[index];
        return _ColorSchemeRow(
          propertyName: resolver.name,
          colorResolver: resolver.resolver,
          lightTheme: lightTheme,
          darkTheme: darkTheme,
        );
      },
    );
  }
}

class _ColorResolver {
  final String name;
  final Color Function(ColorScheme scheme, AppColorsExtension? ext) resolver;
  _ColorResolver(this.name, this.resolver);
}

class _ColorSchemeResolver {
  final String name;
  final Color Function(ColorScheme scheme) resolver;
  _ColorSchemeResolver(this.name, this.resolver);
}

class _TokenRow extends StatelessWidget {
  final String tokenName;
  final Color Function(ColorScheme scheme, AppColorsExtension? ext) colorResolver;
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  const _TokenRow({
    required this.tokenName,
    required this.colorResolver,
    required this.lightTheme,
    required this.darkTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: Token Name
            SizedBox(
              width: 90,
              child: Tooltip(
                message: tokenName,
                child: Text(
                  tokenName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // Right: Light and Dark swatches side-by-side
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Theme(
                  data: lightTheme,
                  child: Builder(
                    builder: (themeContext) {
                      final themeVal = Theme.of(themeContext);
                      final scheme = themeVal.colorScheme;
                      final ext = themeVal.extension<AppColorsExtension>();
                      final color = colorResolver(scheme, ext);
                      return buildColorChip(themeContext, color, isDarkTheme: false);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Theme(
                  data: darkTheme,
                  child: Builder(
                    builder: (themeContext) {
                      final themeVal = Theme.of(themeContext);
                      final scheme = themeVal.colorScheme;
                      final ext = themeVal.extension<AppColorsExtension>();
                      final color = colorResolver(scheme, ext);
                      return buildColorChip(themeContext, color, isDarkTheme: true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
Widget buildColorChip(BuildContext context, Color color, {required bool isDarkTheme}) {
  final hexString = '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  final chipBgColor = isDarkTheme ? Colors.black : Colors.white;
  final chipBorderColor = Colors.black;
  final textColor = isDarkTheme ? Colors.white : Colors.black;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    decoration: BoxDecoration(
      color: chipBgColor,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: chipBorderColor, width: 1),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: isDarkTheme ? Colors.white : Colors.black, width: .5),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          hexString,
          style: TextStyle(
            color: textColor,
            fontFamily: 'monospace',
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),

      ],
    ),
  );
}

class _ColorSchemeRow extends StatelessWidget {
  final String propertyName;
  final Color Function(ColorScheme scheme) colorResolver;
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  const _ColorSchemeRow({
    required this.propertyName,
    required this.colorResolver,
    required this.lightTheme,
    required this.darkTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: Property Name
            SizedBox(
              width: 90,
              child: Tooltip(
                message: propertyName,
                child: Text(
                  propertyName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // Right: Light and Dark swatches side-by-side
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Theme(
                  data: lightTheme,
                  child: Builder(
                    builder: (themeContext) {
                      final themeVal = Theme.of(themeContext);
                      final scheme = themeVal.colorScheme;
                      final color = colorResolver(scheme);
                      return buildColorChip(themeContext, color, isDarkTheme: false);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Theme(
                  data: darkTheme,
                  child: Builder(
                    builder: (themeContext) {
                      final themeVal = Theme.of(themeContext);
                      final scheme = themeVal.colorScheme;
                      final color = colorResolver(scheme);
                      return buildColorChip(themeContext, color, isDarkTheme: true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

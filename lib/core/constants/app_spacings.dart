import 'package:flutter/cupertino.dart';

import '../theme/app_theme.dart';

class AppSpacings {
  AppSpacings._();

  // Spacings
  static const double spacingSmall = 4.0;
  static const double spacingMedium = 8.0;
  static const double spacingLarge = 16.0;
  static const double spacingExtraLarge = 24.0;

  // icon sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconExtraLarge = 48.0;

  // radius
  static const double radiusSmall = 25.0;

  // shadows/elevations
  static List<Shadow> textShadows(BuildContext context) {
    return [
      Shadow(
        blurRadius: 10,
        color: AppTheme.getBrightnessColor(context),
        offset: Offset.zero,
      ),
    ];
  }

}
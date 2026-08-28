import 'package:flutter/cupertino.dart';

import '../theme/app_theme.dart';

class AppSpacings {
  AppSpacings._();

  // Spacings
  static const double spaceXxs = 4.0;
  static const double spaceXs = 8.0;
  static const double spaceSm = 12.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 20.0;
  static const double spaceXl = 24.0;
  static const double spaceXxl = 32.0;
  // scaffold top, horizontal
  static const double scaffoldTop = 8.0;
  static const double scaffoldHorizontal = 16.0;


  // icon sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconExtraLarge = 48.0;

  // radius
  static const double radiusSm = 12.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 24.0;
  static const double radiusXl = 32.0;
  static const double radiusPill = 999.0;
  static const double radiusCircle = 9999.0;//50%

  // shadows/elevations
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  static const double elevationExtraHigh = 16.0;

  // Legacy aliases to preserve compilation in other screens
  static const double spacingSmall = spaceXxs;
  static const double spacingMedium = spaceXs;
  static const double spacingLarge = spaceMd;
  static const double spacingExtraLarge = spaceXl;
  static const double radiusSmall = 25.0;

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
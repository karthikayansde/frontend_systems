import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class AppThemeModel {
  final String key;
  final String name;
  final ThemeData data;
  final ThemeMode mode;

  AppThemeModel({
    required this.key,
    required this.name,
    required this.data,
    required this.mode,
  });
}

class AppColorSchemes {
  final TextTheme _textTheme;

  AppColorSchemes(this._textTheme);

  ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.light,
      primary: AppColors.seed,
      onPrimary: Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
      ),
      extensions: extensionColors,
      textTheme: _textTheme,
    );
  }

  ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.dark,
      primary: AppColors.seed,
      onPrimary: Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerHigh,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFD0BCFF),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFD0BCFF),
        ),
      ),
      extensions: extensionColors,
      textTheme: _textTheme,
    );
  }

  static const String defaultThemeKey = "system";

  List<AppThemeModel> get options => [
    AppThemeModel(
      key: "system",
      name: AppStrings.themeSystem,
      mode: ThemeMode.system,
      data: light, // Default to light if system is requested but context not available
    ),
    AppThemeModel(
      key: "light",
      name: AppStrings.themeLight,
      mode: ThemeMode.light,
      data: light,
    ),
    AppThemeModel(
      key: "dark",
      name: AppStrings.themeDark,
      mode: ThemeMode.dark,
      data: dark,
    ),
  ];
}

List<AppColorsExtension> extensionColors = [
  const AppColorsExtension(
    success: AppColors.success,
    warning: AppColors.warning,
    info: AppColors.info,
  ),
];

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color success;
  final Color warning;
  final Color info;

  const AppColorsExtension({
    required this.success,
    required this.warning,
    required this.info,
  });

  @override
  ThemeExtension<AppColorsExtension> copyWith({Color? success, Color? warning, Color? info}) {
    return AppColorsExtension(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

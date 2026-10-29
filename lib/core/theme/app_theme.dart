import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../shared_services/local_storage/i_local_storage.dart';
import 'app_color_schemes.dart';

class AppTheme {
  final bool isNative;
  final List<AppThemeModel> colorSchemes;
  final ILocalStorage storage;
  // --- singleton start ---
  static AppTheme? _instance;
  AppTheme._internal({
    required this.isNative,
    required this.colorSchemes,
    required this.storage,
  });
  factory AppTheme({
    required bool isNative,
    required List<AppThemeModel> colorSchemes,
    required ILocalStorage storage,
  }){
    _instance ??= AppTheme._internal(
        isNative: isNative,
        colorSchemes: colorSchemes,
        storage: storage,
      );
    return _instance!;
  }
  static bool get isInitialized => _instance != null;

  static AppTheme get instance {
    if (_instance == null) {
      throw Exception("AppTheme must be initialized by calling the factory constructor first.");
    }
    return _instance!;
  }
  // --- singleton over ---

  // --- storage area start ---
  final _storageKey = 'app_theme';
  final _timeFormatKey = 'time_format';
  final _calendarFormatKey = 'calendar_format';

  Future<void> setTheme(String themeKey) async {
    await storage.write(_storageKey, themeKey);
  }
  String getTheme() {
    return storage.read(_storageKey) ?? AppColorSchemes.defaultThemeKey;
  }

  Future<void> setTimeFormat(String format) async {
    await storage.write(_timeFormatKey, format);
  }

  String getTimeFormat() {
    return storage.read(_timeFormatKey) ?? '12h';
  }

  Future<void> setCalendarFormat(String format) async {
    await storage.write(_calendarFormatKey, format);
  }

  String getCalendarFormat() {
    return storage.read(_calendarFormatKey) ?? 'dd MMM yyyy';
  }
  // --- storage area over ---

  // --- dropdown UI builder start ---
  Widget dropdownBuilder(
      Widget Function(
          String selectedKey,
          Map<String, AppThemeModel> themeMap,
          void Function(String key) changeTheme,
          ) builder,
      ) {
    return _AppThemeDropdownBuilder(appTheme: this, builder: builder);
  }
  // --- dropdown UI builder over ---

  // --- app theme builder start ---
  Widget themeWrapper(
    Widget Function(
          ThemeData theme,
          ThemeData darkTheme,
          ThemeMode themeMode
    ) builder,
  ) {
    final String selectedTheme = getTheme();
    return isNative? _AppThemeBuilder(selectedTheme: selectedTheme, colorSchemes: colorSchemes, builder: builder) : _GetAppThemeBuilder(selectedTheme: selectedTheme, colorSchemes: colorSchemes, builder: builder);
  }
  // --- app theme builder over ---

  // --- update theme start ---
  Future<void> updateTheme(String themeKey) async {
    await setTheme(themeKey);
    if(isNative){
      NormalThemeController().setTheme(themeKey);
    }else{
      Get.find<GetThemeController>().setTheme(themeKey);
    }
  }
  // --- update theme over ---

  // --- get brightness color ---
  static Color getBrightnessColor(BuildContext context){
    return Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.black;
  }
  // --- get brightness color ---
}

// --- drop down class start ---
class _AppThemeDropdownBuilder extends StatefulWidget {
  final AppTheme appTheme;
  final Widget Function(
    String selectedKey,
    Map<String, AppThemeModel> themeMap,
    void Function(String key) changeTheme,
  ) builder;

  const _AppThemeDropdownBuilder({
    required this.appTheme,
    required this.builder,
  });

  @override
  State<_AppThemeDropdownBuilder> createState() => _AppThemeDropdownBuilderState();
}

class _AppThemeDropdownBuilderState extends State<_AppThemeDropdownBuilder> {
  late String _selectedKey;

  @override
  void initState() {
    super.initState();
    _selectedKey = widget.appTheme.getTheme();
  }

  void _changeTheme(String key) {
    widget.appTheme.updateTheme(key);
    setState(() => _selectedKey = key);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      _selectedKey,
      {for (var s in widget.appTheme.colorSchemes) s.key: s},
      _changeTheme,
    );
  }
}
// --- drop down class over ---

// normal or flutter theme
class NormalThemeController {
  static final NormalThemeController _singleton = NormalThemeController._internal();
  factory NormalThemeController() {
    return _singleton;
  }
  NormalThemeController._internal();
  // controller area
  final ValueNotifier<String> currentTheme = ValueNotifier(AppColorSchemes.defaultThemeKey);

  // Method to set a specific theme
  void setTheme(String type) {
    currentTheme.value = type;
  }
}

class _AppThemeBuilder extends StatefulWidget {
  final List<AppThemeModel> colorSchemes;
  final String selectedTheme;
  final Widget Function(
    ThemeData theme,
    ThemeData darkTheme,
    ThemeMode themeMode,
  ) builder;

  const _AppThemeBuilder({
    required this.selectedTheme,
    required this.colorSchemes,
    required this.builder,
  });

  @override
  State<_AppThemeBuilder> createState() => _AppThemeBuilderState();
}

class _AppThemeBuilderState extends State<_AppThemeBuilder> {
  final NormalThemeController _controller = NormalThemeController();

  @override
  void initState() {
    super.initState();
    if (_controller.currentTheme.value != widget.selectedTheme) {
      _controller.setTheme(widget.selectedTheme);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _controller.currentTheme,
      builder: (context, themeKey, child) {
        final resolvedTheme = widget.colorSchemes.firstWhere(
          (e) => e.key == themeKey,
          orElse: () => widget.colorSchemes.firstWhere(
            (element) => element.key == AppColorSchemes.defaultThemeKey,
            orElse: () => widget.colorSchemes.first,
          ),
        );

        final lightTheme = widget.colorSchemes.firstWhere(
          (e) => e.mode == ThemeMode.light,
          orElse: () => widget.colorSchemes.first,
        ).data;

        final darkTheme = widget.colorSchemes.firstWhere(
          (e) => e.mode == ThemeMode.dark,
          orElse: () => widget.colorSchemes.last,
        ).data;

        ThemeData effectiveTheme = lightTheme;
        ThemeData effectiveDarkTheme = darkTheme;
        ThemeMode themeMode = resolvedTheme.mode;

        if (resolvedTheme.mode == ThemeMode.dark) {
          effectiveDarkTheme = resolvedTheme.data;
        } else if (resolvedTheme.mode == ThemeMode.light) {
          effectiveTheme = resolvedTheme.data;
        }

        return widget.builder(effectiveTheme, effectiveDarkTheme, themeMode);
      },
    );
  }
}

// getX theme
class GetThemeController extends GetxController {
  final List<AppThemeModel> colorSchemes;
  final RxString currentThemeKey = AppColorSchemes.defaultThemeKey.obs;
  final Rx<ThemeMode> currentThemeMode = ThemeMode.system.obs;

  GetThemeController(this.colorSchemes);

  void setTheme(String themeKey) {
    currentThemeKey.value = themeKey;
    for(var theme in colorSchemes){
      if(theme.key == themeKey){
        currentThemeMode.value = theme.mode;
        Get.changeThemeMode(theme.mode);
        Get.changeTheme(theme.data);
        break;
      }
    }
  }
}

class _GetAppThemeBuilder extends StatefulWidget {
  final String selectedTheme;
  final List<AppThemeModel> colorSchemes;
  final Widget Function(
    ThemeData theme,
    ThemeData darkTheme,
    ThemeMode themeMode,
  ) builder;

  const _GetAppThemeBuilder({
    required this.selectedTheme,
    required this.colorSchemes,
    required this.builder,
  });

  @override
  State<_GetAppThemeBuilder> createState() => _GetAppThemeBuilderState();
}

class _GetAppThemeBuilderState extends State<_GetAppThemeBuilder> {
  late final GetThemeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<GetThemeController>()
        ? Get.find<GetThemeController>()
        : Get.put(GetThemeController(widget.colorSchemes));
    _controller.setTheme(widget.selectedTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeKey = _controller.currentThemeKey.value;
      final resolvedTheme = widget.colorSchemes.firstWhere(
        (e) => e.key == themeKey,
        orElse: () => widget.colorSchemes.firstWhere(
          (element) => element.key == AppColorSchemes.defaultThemeKey,
          orElse: () => widget.colorSchemes.first,
        ),
      );

      final lightTheme = widget.colorSchemes.firstWhere(
        (e) => e.mode == ThemeMode.light,
        orElse: () => widget.colorSchemes.first,
      ).data;

      final darkTheme = widget.colorSchemes.firstWhere(
        (e) => e.mode == ThemeMode.dark,
        orElse: () => widget.colorSchemes.last,
      ).data;

      ThemeData effectiveTheme = lightTheme;
      ThemeData effectiveDarkTheme = darkTheme;
      ThemeMode themeMode = resolvedTheme.mode;

      if (resolvedTheme.mode == ThemeMode.dark) {
        effectiveDarkTheme = resolvedTheme.data;
      } else if (resolvedTheme.mode == ThemeMode.light) {
        effectiveTheme = resolvedTheme.data;
      }

      return widget.builder(effectiveTheme, effectiveDarkTheme, themeMode);
    });
  }
}

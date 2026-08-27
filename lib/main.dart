import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_color_schemes.dart';
import 'core/theme/app_text_theme.dart';
import 'core/shared_services/local_storage/local_storage.dart';
import 'core/shared_services/local_storage/mock_local_storage.dart';
import 'core/shared_widgets/smart_snack_bar.dart';
import 'core/shared_widgets/smart_dialogs.dart';
import 'presentation/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  final storage = LocalStorageService();
  await storage.init();

  // Initialize theme controller singleton
  final colorSchemes = AppColorSchemes(AppTextTheme.textTheme).options;
  AppTheme(
    isNative: true,
    colorSchemes: colorSchemes,
    storage: storage,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppTheme themeInstance;
    try {
      themeInstance = AppTheme.instance;
    } catch (_) {
      final colorSchemes = AppColorSchemes(AppTextTheme.textTheme).options;
      themeInstance = AppTheme(
        isNative: true,
        colorSchemes: colorSchemes,
        storage: MockLocalStorage(),
      );
    }

    return themeInstance.themeWrapper(
      (theme, darkTheme, themeMode) {
        return MaterialApp(
          title: 'Snack Bar & Dialog Demo',
          theme: theme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          scaffoldMessengerKey: SmartSnackBars.messengerKey,
          navigatorKey: SmartDialogs.navigatorKey,
          home: const HomePage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
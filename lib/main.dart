import 'package:flutter/material.dart';
import 'package:frontend_systems/core/shared_widgets/smart_dialogs.dart';
import 'package:frontend_systems/core/shared_widgets/smart_snack_bar.dart';

// A notifier to manage the theme mode state dynamically across the app
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentThemeMode, _) {
        return MaterialApp(
          title: 'Snack Bar & Dialog Demo',
          // CRITICAL: Register the messenger key here to allow showing snackbars without context
          scaffoldMessengerKey: SmartSnackBars.messengerKey,
          navigatorKey: SmartDialogs.navigatorKey,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: currentThemeMode,
          home: const MyHomePage(title: 'Snack Bar & Dialog Demo'),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  void _showSampleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Dialog Snack Bar Demo'),
          content: const Text(
            'Compare how standard SnackBars and Overlay SnackBars behave when a dialog is open:\n\n'
            '• Standard SnackBars appear behind the dialog route.\n'
            '• Overlay SnackBars appear on top of the dialog.',
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              onPressed: () {
                SmartSnackBars.show(
                  message: 'This is a standard SnackBar (shown behind dialog)!',
                  type: NotificationType.info,
                );
              },
              icon: const Icon(Icons.info_outline),
              label: const Text('Show SnackBar'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Important: Use context here to display overlay
                SmartSnackBars.showOverlay(
                  dialogContext,
                  message: 'This is an overlay SnackBar (shown on top of dialog)!',
                  type: NotificationType.success,
                );
              },
              icon: const Icon(Icons.layers_outlined),
              label: const Text('Show Overlay SnackBar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Standard Snack Bar Types',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Trigger different styles of snackbars using SmartSnackBars.show()',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Success SnackBar Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.green.shade900.withValues(alpha: 0.3) : Colors.green.shade50,
                foregroundColor: isDarkMode ? Colors.green.shade100 : Colors.green.shade900,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                SmartSnackBars.show(
                  message: 'Operation completed successfully!',
                  type: NotificationType.success,
                );
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Show Success SnackBar', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),

            // Error SnackBar Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.red.shade900.withValues(alpha: 0.3) : Colors.red.shade50,
                foregroundColor: isDarkMode ? Colors.red.shade100 : Colors.red.shade900,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                SmartSnackBars.show(
                  message: 'An error occurred. Please try again.',
                  type: NotificationType.error,
                );
              },
              icon: const Icon(Icons.error_outline),
              label: const Text('Show Error SnackBar', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),

            // Warning SnackBar Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.orange.shade900.withValues(alpha: 0.3) : Colors.orange.shade50,
                foregroundColor: isDarkMode ? Colors.orange.shade100 : Colors.orange.shade900,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                SmartSnackBars.show(
                  message: 'Warning: Storage space is running low.',
                  type: NotificationType.warning,
                  actionLabel: 'CLEANUP',
                  onAction: () {
                    SmartSnackBars.show(
                      message: 'Cleanup process started!',
                      type: NotificationType.info,
                    );
                  },
                );
              },
              icon: const Icon(Icons.warning_amber_rounded),
              label: const Text('Show Warning SnackBar with Action', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),

            // Info SnackBar Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.blue.shade900.withValues(alpha: 0.3) : Colors.blue.shade50,
                foregroundColor: isDarkMode ? Colors.blue.shade100 : Colors.blue.shade900,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                SmartSnackBars.show(
                  message: 'Did you know? You can dismiss snack bars manually.',
                  type: NotificationType.info,
                );
              },
              icon: const Icon(Icons.info_outline),
              label: const Text('Show Info SnackBar', style: TextStyle(fontSize: 16)),
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Divider(),
            ),

            const Text(
              'Dialog & Overlay Demo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Open a dialog to see how standard SnackBars fail to show on top of dialog routes, and how Overlay SnackBars solve this problem.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Show Dialog Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.teal.shade900.withValues(alpha: 0.3) : Colors.teal.shade50,
                foregroundColor: isDarkMode ? Colors.teal.shade100 : Colors.teal.shade900,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: isDarkMode ? Colors.teal.shade700 : Colors.teal.shade200, width: 1.5),
                ),
              ),
              onPressed: () => _showSampleDialog(context),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open Sample Dialog', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Divider(),
            ),

            const Text(
              'Global Smart Dialogs (Context-Free)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Trigger dialogs and loadings from anywhere in your app without passing BuildContext.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Smart Alert Dialog Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.indigo.shade900.withValues(alpha: 0.3) : Colors.indigo.shade50,
                foregroundColor: isDarkMode ? Colors.indigo.shade100 : Colors.indigo.shade900,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                SmartDialogs.showAlert(
                  title: 'Success Alert',
                  message: 'This alert dialog was shown using SmartDialogs without passing BuildContext!',
                );
              },
              icon: const Icon(Icons.info),
              label: const Text('Show Smart Alert', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),

            // Smart Confirmation Dialog Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.deepPurple.shade900.withValues(alpha: 0.3) : Colors.deepPurple.shade50,
                foregroundColor: isDarkMode ? Colors.deepPurple.shade100 : Colors.deepPurple.shade900,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                final confirmed = await SmartDialogs.showConfirmation(
                  title: 'Confirm Action',
                  message: 'Are you sure you want to proceed? This is a context-free dialog.',
                  buttonColor: Colors.deepPurple,
                  buttonText: 'Confirm',
                  cancelButtonText: 'Cancel',
                );

                if (confirmed == true) {
                  SmartSnackBars.show(
                    message: 'Confirmed!',
                    type: NotificationType.success,
                  );
                } else if (confirmed == false) {
                  SmartSnackBars.show(
                    message: 'Cancelled!',
                    type: NotificationType.info,
                  );
                }
              },
              icon: const Icon(Icons.help_outline),
              label: const Text('Show Smart Confirmation', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),

            // Smart Loading Dialog Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.amber.shade900.withValues(alpha: 0.3) : Colors.amber.shade50,
                foregroundColor: isDarkMode ? Colors.amber.shade100 : Colors.amber.shade900,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                SmartDialogs.showLoading(message: 'Processing request...');
                Future.delayed(const Duration(seconds: 4), () {
                  SmartDialogs.hideLoading();
                  SmartSnackBars.show(
                    message: 'Process completed successfully!',
                    type: NotificationType.success,
                  );
                });
              },
              icon: const Icon(Icons.hourglass_empty_rounded),
              label: const Text('Show Smart Loading (4s Auto-Dismiss)', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Toggle Theme',
        onPressed: () {
          themeNotifier.value = themeNotifier.value == ThemeMode.light
              ? ThemeMode.dark
              : ThemeMode.light;
        },
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, currentThemeMode, _) {
            final isDark = currentThemeMode == ThemeMode.dark;
            return Icon(isDark ? Icons.light_mode : Icons.dark_mode);
          },
        ),
      ),
    );
  }
}

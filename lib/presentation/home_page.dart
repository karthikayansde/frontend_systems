import 'package:flutter/material.dart';
import '../core/constants/app_spacings.dart';
import '../core/shared_services/navigation_service.dart';
import '../core/shared_widgets/smart_snack_bar.dart';
import '../core/theme/app_theme.dart';
import 'colors_screen.dart';
import 'typography_screen.dart';
import 'snack_bars_screen.dart';
import 'dialogs_screen.dart';
import 'spacings_screen.dart';
import 'buttons_screen.dart';
import 'form_fields_screen.dart';
import 'navigation_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _getScreenForSection(String title) {
    switch (title) {
      case 'Colors':
        return const ColorsScreen();
      case 'Typography':
        return const TypographyScreen();
      case 'Snack Bars':
        return const SnackBarsScreen();
      case 'Buttons':
        return const ButtonsScreen();
      case 'Dialogs & Popups':
        return const DialogsScreen();
      case 'Spacings':
        return const SpacingsScreen();
      case 'Form Fields':
        return const FormFieldsScreen();
      case 'Navigation Styles':
        return const NavigationScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Define the list of design system sections
    final sections = [
      _DesignSystemSection('Colors', '🎨'),
      _DesignSystemSection('Typography', '🔤'),
      _DesignSystemSection('Snack Bars', '🔔'),
      _DesignSystemSection('Buttons', '🔘'),
      _DesignSystemSection('Dialogs & Popups', '💬'),
      _DesignSystemSection('Spacings', '📏'),
      _DesignSystemSection('Form Fields', '📝'),
      _DesignSystemSection('Navigation Styles', '🚀'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Snack Bar & Dialog Demo'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: AppTheme.instance.dropdownBuilder(
              (selectedKey, themeMap, changeTheme) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedKey,
                      icon: const Icon(Icons.palette_outlined, size: 20),
                      onChanged: (key) {
                        if (key != null) {
                          changeTheme(key);
                        }
                      },
                      items: themeMap.entries
                          .map((e) => DropdownMenuItem(
                                value: e.key,
                                child: Text(
                                  e.value.name,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(AppSpacings.spacingLarge),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: sections.length,
                itemBuilder: (context, index) {
                  final section = sections[index];
                  return Card(
                    elevation: 3,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        final screen = _getScreenForSection(section.title);
                        if (screen is! SizedBox) {
                          SmartNavigation.push(
                            context,
                            screen,
                            transition: SmartTransitionType.slideRight,
                          );
                        } else {
                          SmartSnackBars.show(
                            message: '${section.title} clicked! Navigation coming soon.',
                            type: NotificationType.info,
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacings.spacingLarge),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: AlignmentGeometry.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                  section.emoji,
                                  style: const TextStyle(fontSize: 55),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              section.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesignSystemSection {
  final String title;
  final String emoji;
  _DesignSystemSection(this.title, this.emoji);
}

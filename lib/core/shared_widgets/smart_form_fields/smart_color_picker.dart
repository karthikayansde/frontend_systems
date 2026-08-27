import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import '../../../core/constants/app_spacings.dart';
import '../smart_form_fields/smart_form_field_theme.dart';
import 'smart_buttons.dart';

class SmartColorPickerField extends StatefulWidget {
  final String formControlName;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isGreenWarnNeed;
  final Map<String, ValidationMessageFunction>? validationMessages;
  final void Function(Color? selectedColor)? onChanged;

  const SmartColorPickerField({
    super.key,
    required this.formControlName,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.isGreenWarnNeed = false,
    this.validationMessages,
    this.onChanged,
  });

  @override
  State<SmartColorPickerField> createState() => _SmartColorPickerFieldState();
}

class _SmartColorPickerFieldState extends State<SmartColorPickerField> {
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      (ReactiveForm.of(context) as FormGroup?)?.control(widget.formControlName).markAsTouched();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: ReactiveStatusListenableBuilder(
          formControlName: widget.formControlName,
          builder: (context, control, child) {
            final isValid = control.valid;
            return ReactiveFormField<int, int>(
              formControlName: widget.formControlName,
              validationMessages: widget.validationMessages,
              builder: (ReactiveFormFieldState<int, int> field) {
                final int? colorValue = field.value;
                final Color? currentColor = colorValue != null ? Color(colorValue) : null;
                
                if (colorValue != null) {
                  textEditingController.text = '#${colorValue.toRadixString(16).padLeft(8, '0').toUpperCase().substring(2)}';
                } else {
                  textEditingController.text = '';
                }

                final bool isControlDisabled = field.control.disabled;
                return TextFormField(
                  onTapOutside: (PointerDownEvent event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  style: const TextStyle(color: Colors.transparent, height: 0),
                  controller: textEditingController,
                  focusNode: _focusNode,
                  enabled: !isControlDisabled,
                  onTap: isControlDisabled
                      ? null
                      : () async {
                    field.control.markAsTouched();
                    final selected = await _showColorPicker(
                      context,
                      currentColor: currentColor ?? Colors.blue,
                    );
                    if (selected != null) {
                      field.didChange(selected.toARGB32());
                      if (widget.onChanged != null) {
                        widget.onChanged!(selected);
                      }
                    }
                  },
                  decoration: InputDecoration(
                    isDense: false,
                    prefixIcon: currentColor != null
                        ? (widget.prefixIcon ?? Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              width: 85,
                              height: 44,
                              decoration: BoxDecoration(
                                color: currentColor,
                                borderRadius: BorderRadius.circular(SmartFormFieldTheme.radius),
                                boxShadow: [
                                  BoxShadow(
                                    color: currentColor.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ))
                        : null,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.suffixIcon != null) widget.suffixIcon!,
                        if (widget.isGreenWarnNeed && isValid && control.value != null)
                          Icon(Icons.check_circle, color: SmartFormFieldTheme.successColor),
                      ],
                    ),
                    errorText: field.errorText,
                    labelText: widget.labelText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SmartFormFieldTheme.radius),
                      borderSide: const BorderSide(width: SmartFormFieldTheme.borderWidth),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SmartFormFieldTheme.radius),
                      borderSide: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: SmartFormFieldTheme.borderWidth,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SmartFormFieldTheme.radius),
                      borderSide: BorderSide(
                        width: SmartFormFieldTheme.focusedBorderWidth,
                        color: SmartFormFieldTheme.primaryColor,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SmartFormFieldTheme.radius),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                        width: SmartFormFieldTheme.borderWidth,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SmartFormFieldTheme.radius),
                      borderSide: BorderSide(
                        width: SmartFormFieldTheme.focusedBorderWidth,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                  readOnly: true,
                  showCursor: false,
                  enableInteractiveSelection: false,
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// Common Dialog for Color Selection
  Future<Color?> _showColorPicker(
      BuildContext context, {
        Color? currentColor,
      }) async
  {
    Color selectedColor = currentColor ?? Colors.blue;

    return showDialog<Color>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SmartFormFieldTheme.radius)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
            padding: const EdgeInsets.all(AppSpacings.spacingLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header (Common with Emoji Picker)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select Color',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Color Picker Content
                Flexible(
                  child: SingleChildScrollView(
                    child: ColorPicker(
                      color: selectedColor,
                      onColorChanged: (Color color) {
                        selectedColor = color;
                      },
                      width: 44,
                      height: 44,
                      // spacing: 8,
                      runSpacing: 8,
                      borderRadius: 12,
                      wheelDiameter: 165,
                      enableOpacity: false,
                      showColorCode: true,
                      colorCodeHasColor: true,
                      pickersEnabled: const <ColorPickerType, bool>{
                        ColorPickerType.primary: true,
                        ColorPickerType.accent: true,
                        ColorPickerType.wheel: true,
                      },
                      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                        longPressMenu: false,
                        copyButton: false,
                        pasteButton: false,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Action Buttons at the bottom
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    SmartPrimaryButton(
                      width: 100,
                      height: 45,
                      onPressed: () async => Navigator.pop(context, selectedColor),
                      label: 'Select',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

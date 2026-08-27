import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'smart_form_field_theme.dart';

/// A reusable smart check/radio box widget for reactive forms.
/// 
/// Behaves like:
/// - A radio group for single-select (`isSingleSelect: true`).
/// - A checkbox list for multi-select (`isSingleSelect: false`).
class SmartCheckRadioBox<T> extends StatelessWidget {
  final String formControlName;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isGreenWarnNeed;
  final Map<String, ValidationMessageFunction>? validationMessages;
  final void Function(dynamic value)? onChanged;
  
  /// Items must be a List of Maps containing the form value and display label.
  /// Example: `[{"1": "Daily"}, {"2": "Weekly"}]`
  final List<Map<T, String>> items;
  final bool isSingleSelect;
  final bool isWrap;

  const SmartCheckRadioBox({
    super.key,
    required this.formControlName,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.isGreenWarnNeed = false,
    this.validationMessages,
    this.onChanged,
    required this.items,
    this.isSingleSelect = true,
    this.isWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: ReactiveStatusListenableBuilder(
          formControlName: formControlName,
          builder: (context, control, child) {
            final isValid = control.valid;
            
            return ReactiveFormField<dynamic, dynamic>(
              formControlName: formControlName,
              validationMessages: validationMessages,
              builder: (field) {
                final bool isControlDisabled = field.control.disabled;

                final decoration = InputDecoration(
                  enabled: !isControlDisabled,
                  isDense: false,
                  labelText: labelText,
                  prefixIcon: prefixIcon,
                  errorText: field.errorText,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (suffixIcon != null) suffixIcon!,
                      if (isGreenWarnNeed && isValid && field.value != null && (field.value is! List || (field.value as List).isNotEmpty))
                        Icon(Icons.check_circle, color: SmartFormFieldTheme.successColor),
                    ],
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                );

                final children = items.map((item) {
                  final key = item.keys.first;
                  final value = item.values.first;

                  Widget tile;

                  // Special case: If the field is a boolean control, render a simple boolean checkbox
                  if (key is bool || field.value is bool) {
                    tile = Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        dense: true,
                        value: (field.value as bool?) ?? false,
                        title: Text(value, style: Theme.of(context).textTheme.bodyMedium),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: isControlDisabled
                            ? null
                            : (checked) {
                          field.didChange(checked);
                          onChanged?.call(checked);
                        },
                      ),
                    );
                  } else if (isSingleSelect) {
                    tile = Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: RadioListTile<T>(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        dense: true,
                        value: key,
                        groupValue: field.value as T?,
                        title: Text(value, style: Theme.of(context).textTheme.bodyMedium),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: isControlDisabled
                            ? null
                            : (newValue) {
                          field.didChange(newValue);
                          onChanged?.call(newValue);
                        },
                      ),
                    );
                  } else {
                    // Ensure we handle the value as a list for multi-select
                    final listValue = (field.value is Iterable) 
                        ? (field.value as Iterable).toList() 
                        : [];
                    final isChecked = listValue.contains(key);
                    
                    tile = Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        dense: true,
                        value: isChecked,
                        title: Text(value, style: Theme.of(context).textTheme.bodyMedium),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: isControlDisabled
                            ? null
                            : (checked) {
                          final newList = List<dynamic>.from(listValue);
                          if (checked == true) {
                            if (!newList.contains(key)) newList.add(key);
                          } else {
                            newList.remove(key);
                          }

                          final result = (T == dynamic) ? newList : newList.cast<T>().toList();

                          // Pass null when empty so Validators.required fires correctly
                          // (required only fails on null, not on [])
                          field.didChange(result.isEmpty ? null : result);
                          onChanged?.call(result.isEmpty ? null : result);
                        },
                      ),
                    );
                  }
                  
                  if (isWrap) {
                    return IntrinsicWidth(child: tile);
                  }
                  return tile;
                }).toList();

                return Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      field.control.markAsTouched();
                    }
                  },
                  child: InputDecorator(
                    decoration: decoration,
                    child: isWrap
                        ? Wrap(
                            spacing: 8.0,
                            runSpacing: 0.0,
                            children: children,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: children,
                          ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'smart_form_field_theme.dart';

class SmartTextField extends StatefulWidget {
  final String formControlName;
  final String labelText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool isGreenWarnNeed;
  final Map<String, ValidationMessageFunction>? validationMessages;
  final ReactiveFormFieldCallback<String>? onChanged;
  
  final TextInputType? keyboardType;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool isPasswordField;
  final String? showString;
  final String? hideString;
  final double? maxWidth;
  final String? hintText;

  const SmartTextField({
    super.key,
    required this.formControlName,
    required this.labelText,
    this.suffixIcon,
    this.prefixIcon,
    this.isGreenWarnNeed = false,
    this.validationMessages,
    this.onChanged,
    this.keyboardType,
    this.maxLines,
    this.inputFormatters,
    this.isPasswordField = false,
    this.showString,
    this.hideString,
    this.maxWidth = 450,
    this.hintText,
  });

  @override
  State<SmartTextField> createState() => _SmartTextFieldState();
}

class _SmartTextFieldState extends State<SmartTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPasswordField;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    Widget content = Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: ReactiveStatusListenableBuilder(
        formControlName: widget.formControlName,
        builder: (context, control, child) {
          final isValid = control.valid;
          return ReactiveTextField<String>(
            formControlName: widget.formControlName,
            validationMessages: widget.validationMessages,
            textCapitalization: TextCapitalization.sentences,

            onTapOutside: (PointerDownEvent event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            showErrors: (control) => control.invalid && (control.touched || control.dirty),
            keyboardType: widget.keyboardType,
            maxLines: _obscureText ? 1 : widget.maxLines,
            obscureText: _obscureText,
            onChanged: widget.onChanged,
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              isDense: false,
              labelText: widget.labelText,
              hintText: widget.hintText,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.suffixIcon != null) widget.suffixIcon!,
                  if (widget.isPasswordField)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 4.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          minimumSize: const Size(55, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(SmartFormFieldTheme.radius),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Text(
                          _obscureText ? widget.showString ?? 'Show' : widget.hideString ?? 'Hide',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  if (widget.isGreenWarnNeed && isValid && control.value != null && (control.value as String).isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.check_circle, color: SmartFormFieldTheme.successColor),
                    ),
                ],
              ),
              prefixIcon: widget.prefixIcon,
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
                  color: primaryColor,
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
          );
        },
      ),
    );

    if (widget.maxWidth != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxWidth!),
        child: content,
      );
    }
    return content;
  }
}

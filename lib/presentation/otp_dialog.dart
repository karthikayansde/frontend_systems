import 'dart:async'; // Required for Timer
import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../core/constants/app_spacings.dart';
import '../core/constants/app_strings.dart';
import '../core/forms/field_config.dart';
import '../core/forms/smart_form.dart';
import '../core/shared_widgets/smart_dialogs.dart';
import '../core/shared_widgets/smart_snack_bar.dart';

class OtpForm extends SmartForm {
  @override
  Map<String, FieldConfig> get configs => {
        'otp': FieldConfig.text(
          key: 'otp',
          label: 'One-Time Password',
          required: true,
          validators: [
            Validators.minLength(6),
            Validators.maxLength(6),
            Validators.pattern(RegExp(r'^\d{6}$')), // digits only
          ],
          validationMessages: {
            ValidationMessage.required: (_) => 'OTP is required.',
            ValidationMessage.pattern: (_) => 'OTP must be exactly 6 digits.',
            ValidationMessage.minLength: (_) => 'OTP must be exactly 6 digits.',
            ValidationMessage.maxLength: (_) => 'OTP must be exactly 6 digits.',
          },
        ),
      };
}

class OtpDialog extends StatefulWidget {
  final String email;
  final ValueNotifier<int> secondsRemainingNotifier;
  final Future<void> Function(String otp) onVerify;
  final Future<void> Function() onResend;
  final String? title;
  final String? subtitle;
  final String? verifyButtonText;
  final String? resendPrefixText;
  final String? resendActionText;
  final String? resendSuccessMessage;
  final String Function(int seconds)? resendTimerTextBuilder;

  const OtpDialog({
    super.key,
    required this.email,
    required this.secondsRemainingNotifier,
    required this.onVerify,
    required this.onResend,
    this.title,
    this.subtitle,
    this.verifyButtonText,
    this.resendPrefixText,
    this.resendActionText,
    this.resendSuccessMessage,
    this.resendTimerTextBuilder,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String email,
    required ValueNotifier<int> secondsRemainingNotifier,
    required Future<void> Function(String otp) onVerify,
    required Future<void> Function() onResend,
    String? title,
    String? subtitle,
    String? verifyButtonText,
    String? resendPrefixText,
    String? resendActionText,
    String? resendSuccessMessage,
    String Function(int seconds)? resendTimerTextBuilder,
  }) {
    return SmartDialogs.showCustom<bool>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside when operations are active
      builder: (context) => OtpDialog(
        email: email,
        secondsRemainingNotifier: secondsRemainingNotifier,
        onVerify: onVerify,
        onResend: onResend,
        title: title,
        subtitle: subtitle,
        verifyButtonText: verifyButtonText,
        resendPrefixText: resendPrefixText,
        resendActionText: resendActionText,
        resendSuccessMessage: resendSuccessMessage,
        resendTimerTextBuilder: resendTimerTextBuilder,
      ),
    );
  }

  @override
  State<OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  final OtpForm _otpForm = OtpForm();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _otpForm.initForm();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: !_isLoading,
      child: Dialog(
        backgroundColor: theme.dialogTheme.backgroundColor ?? colorScheme.surfaceContainerHigh,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450.0),
          child: AbsorbPointer(
            absorbing: _isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(false),
                    ),
                  ),
                  Text(
                    widget.title ?? AppStrings.otpTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacings.spaceXs),
                  Text(
                    widget.subtitle ?? AppStrings.otpSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacings.spaceXl),
                  _otpForm.formGroupWrap(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _otpForm.buildWidget('otp'),
                        const SizedBox(height: AppSpacings.spaceXl),
                        ReactiveFormConsumer(
                          builder: (context, form, child) {
                            return FilledButton(
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(48.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSpacings.radiusPill),
                                ),
                              ),
                              onPressed: (form.valid && !_isLoading)
                                  ? () async {
                                      try {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        final token = form.control('otp').value as String;
                                        await widget.onVerify(token);
                                        if (mounted) {
                                          Navigator.of(context).pop(true);
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                        SmartSnackBars.showOverlay(
                                          context,
                                          message: e.toString().replaceAll('Exception: ', ''),
                                          type: NotificationType.error,
                                        );
                                      }
                                    }
                                  : () {
                                      if (!_isLoading) {
                                        _otpForm.markAllTouched();
                                      }
                                    },
                              child: _isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                                      ),
                                    )
                                  : Text(
                                      widget.verifyButtonText ?? AppStrings.otpBtn,
                                      style: theme.textTheme.labelLarge?.copyWith(
                                        color: colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacings.spaceXl),
                  ValueListenableBuilder<int>(
                    valueListenable: widget.secondsRemainingNotifier,
                    builder: (context, secondsRemaining, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (secondsRemaining > 0) ...[
                            Text(
                              widget.resendTimerTextBuilder?.call(secondsRemaining) ??
                                  "Resend OTP in ${secondsRemaining}s",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                          ] else ...[
                            Text(
                              widget.resendPrefixText ?? AppStrings.resendOtpText,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: _isLoading
                                  ? null
                                  : () async {
                                      try {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        await widget.onResend();
                                        SmartSnackBars.showOverlay(
                                          context,
                                          message: widget.resendSuccessMessage ?? 'Verification code resent!',
                                          type: NotificationType.success,
                                        );
                                      } catch (e) {
                                        SmartSnackBars.showOverlay(
                                          context,
                                          message: e.toString().replaceAll('Exception: ', ''),
                                          type: NotificationType.error,
                                        );
                                      } finally {
                                        if (mounted) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      }
                                    },
                              child: Text(
                                widget.resendActionText ?? AppStrings.resendOtpAction,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

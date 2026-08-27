import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../core/constants/app_spacings.dart';
import '../core/forms/field_config.dart';
import '../core/forms/smart_form.dart';
import '../core/shared_widgets/smart_snack_bar.dart';
import '../core/shared_widgets/smart_form_fields/smart_buttons.dart';
import '../core/shared_widgets/smart_form_fields/smart_date_time_picker.dart';
import 'otp_dialog.dart';

class DemoFormFields extends SmartForm {
  @override
  late final Map<String, FieldConfig> configs;

  // Text Fields
  static const String usernameField = 'username';
  static const String apiKeyField = 'apiKey';
  static const String emailField = 'email';
  static const String passwordField = 'password';
  static const String bioField = 'bio';
  static const String githubField = 'github';

  // Emoji Fields
  static const String emojiField = 'emoji';
  static const String disabledEmojiField = 'disabledEmoji';
  static const String requiredEmojiField = 'requiredEmoji';

  // Color Fields
  static const String colorField = 'color';
  static const String disabledColorField = 'disabledColor';
  static const String requiredColorField = 'requiredColor';

  // Dropdown Fields
  static const String dropdownField = 'dropdown';
  static const String disabledDropdownField = 'disabledDropdown';
  static const String requiredDropdownField = 'requiredDropdown';
  static const String multiDropdownField = 'multiDropdown';
  static const String disabledMultiDropdownField = 'disabledMultiDropdown';

  // Check / Radio Fields
  static const String radioField = 'radio';
  static const String disabledRadioField = 'disabledRadio';
  static const String checkboxField = 'checkbox';
  static const String disabledCheckboxField = 'disabledCheckbox';
  static const String requiredCheckboxField = 'requiredCheckbox';

  // Date / Time Fields
  static const String dateField = 'date';
  static const String disabledDateField = 'disabledDate';
  static const String requiredDateField = 'requiredDate';
  static const String timeField = 'time';
  static const String disabledTimeField = 'disabledTime';

  // Duration Fields
  static const String durationField = 'duration';
  static const String disabledDurationField = 'disabledDuration';
  static const String requiredDurationField = 'requiredDuration';

  DemoFormFields() {
    configs = {
      // 1. Text Fields
      usernameField: FieldConfig.text(
        key: usernameField,
        label: 'Username',
        required: true,
        validationMessages: {
          ValidationMessage.required: (_) => 'Username is required.',
          ValidationMessage.minLength: (_) => 'Must be at least 4 characters.',
        },
        validators: [Validators.minLength(4)],
      ),
      apiKeyField: FieldConfig.text(
        key: apiKeyField,
        label: 'Read-Only API Key',
        defaultValue: '98274-SECRET-KEY-TOKEN',
      ),
      emailField: FieldConfig.text(
        key: emailField,
        label: 'Email Address',
        required: true,
        prefixIcon: const Icon(Icons.email_rounded),
        suffixIcon: const Icon(Icons.help_outline_rounded),
        validationMessages: {
          ValidationMessage.required: (_) => 'Email is required.',
          ValidationMessage.email: (_) => 'Enter a valid email address.',
        },
        validators: [Validators.email],
      ),
      passwordField: FieldConfig.text(
        key: passwordField,
        label: 'Secret Password',
        required: true,
        isPasswordField: true,
        showString: 'Show Key',
        hideString: 'Hide Key',
        validationMessages: {
          ValidationMessage.required: (_) => 'Password is required.',
          ValidationMessage.minLength: (_) => 'Password must be at least 6 characters.',
        },
        validators: [Validators.minLength(6)],
      ),
      bioField: FieldConfig.text(
        key: bioField,
        label: 'Biography Description',
        maxLines: 3,
      ),
      githubField: FieldConfig.text(
        key: githubField,
        label: 'GitHub Handle',
        required: true,
        isGreenWarnNeed: true,
        validationMessages: {
          ValidationMessage.required: (_) => 'GitHub handle is required.',
        },
      ),

      // 2. Emoji Pickers
      emojiField: FieldConfig.emoji(
        key: emojiField,
        label: 'Emoji Select',
        defaultValue: '🔥',
      ),
      disabledEmojiField: FieldConfig.emoji(
        key: disabledEmojiField,
        label: 'Disabled Emoji Select',
        defaultValue: '⚡',
      ),

      // 3. Color Pickers
      colorField: FieldConfig.color(
        key: colorField,
        label: 'Color Picker',
        defaultValue: 0xFF2196F3, // ARGB Blue
      ),
      disabledColorField: FieldConfig.color(
        key: disabledColorField,
        label: 'Disabled Color Picker',
        defaultValue: 0xFF4CAF50, // ARGB Green
      ),

      // 4. Dropdowns
      dropdownField: FieldConfig.dropdown(
        key: dropdownField,
        label: 'Select Country',
        items: [
          {'US': 'United States'},
          {'IN': 'India'},
          {'CA': 'Canada'},
        ],
        isSingleDropDown: true,
      ),
      disabledDropdownField: FieldConfig.dropdown(
        key: disabledDropdownField,
        label: 'Disabled Select Country',
        items: [
          {'US': 'United States'},
          {'IN': 'India'},
          {'CA': 'Canada'},
        ],
        defaultValue: ['US'],
        isSingleDropDown: true,
      ),
      multiDropdownField: FieldConfig.dropdown(
        key: multiDropdownField,
        label: 'Select Tech Stack',
        items: [
          {'FL': 'Flutter'},
          {'KT': 'Kotlin'},
          {'SW': 'Swift'},
          {'TS': 'TypeScript'},
        ],
        isSingleDropDown: false,
      ),
      disabledMultiDropdownField: FieldConfig.dropdown(
        key: disabledMultiDropdownField,
        label: 'Disabled Select Tech Stack',
        items: [
          {'FL': 'Flutter'},
          {'KT': 'Kotlin'},
          {'SW': 'Swift'},
          {'TS': 'TypeScript'},
        ],
        defaultValue: ['FL', 'TS'],
        isSingleDropDown: false,
      ),

      // 5. Check / Radio Boxes
      radioField: FieldConfig.checkRadio<String>(
        key: radioField,
        label: 'Single Select Option',
        items: [
          {'option1': 'Weekly Update'},
          {'option2': 'Monthly Update'},
          {'option3': 'No Updates'},
        ],
        isSingleSelect: true,
      ),
      disabledRadioField: FieldConfig.checkRadio<String>(
        key: disabledRadioField,
        label: 'Disabled Single Select Option',
        items: [
          {'option1': 'Weekly Update'},
          {'option2': 'Monthly Update'},
          {'option3': 'No Updates'},
        ],
        defaultValue: 'option1',
        isSingleSelect: true,
      ),
      checkboxField: FieldConfig.checkRadio<List<dynamic>>(
        key: checkboxField,
        label: 'Multi Select Options',
        items: [
          {'optA': 'Receive Notifications'},
          {'optB': 'Subscribe Newsletter'},
          {'optC': 'Enable Beta Features'},
        ],
        isSingleSelect: false,
      ),
      disabledCheckboxField: FieldConfig.checkRadio<List<dynamic>>(
        key: disabledCheckboxField,
        label: 'Disabled Multi Select Options',
        items: [
          {'optA': 'Receive Notifications'},
          {'optB': 'Subscribe Newsletter'},
          {'optC': 'Enable Beta Features'},
        ],
        defaultValue: ['optA', 'optC'],
        isSingleSelect: false,
      ),

      // 6. Date / Time Pickers
      dateField: FieldConfig.dateTime<String>(
        key: dateField,
        label: 'Date Picker',
        mode: SmartPickerMode.dateOnly,
        dateFormat: 'yyyy-MM-dd',
      ),
      disabledDateField: FieldConfig.dateTime<String>(
        key: disabledDateField,
        label: 'Disabled Date Picker',
        mode: SmartPickerMode.dateOnly,
        defaultValue: '2026-08-27',
        dateFormat: 'yyyy-MM-dd',
      ),
      timeField: FieldConfig.dateTime<String>(
        key: timeField,
        label: 'Time Picker',
        mode: SmartPickerMode.timeOnly,
        timeFormat: 'hh:mm a',
      ),
      disabledTimeField: FieldConfig.dateTime<String>(
        key: disabledTimeField,
        label: 'Disabled Time Picker',
        mode: SmartPickerMode.timeOnly,
        defaultValue: '14:30',
        timeFormat: 'hh:mm a',
      ),

      // 7. Duration Pickers
      durationField: FieldConfig.duration(
        key: durationField,
        label: 'Duration Picker',
      ),
      disabledDurationField: FieldConfig.duration(
        key: disabledDurationField,
        label: 'Disabled Duration Picker',
        defaultValue: '02:30',
      ),
      requiredEmojiField: FieldConfig.emoji(
        key: requiredEmojiField,
        label: 'Emoji Select',
        required: true,
        validationMessages: {
          ValidationMessage.required: (_) => 'Emoji selection is required.',
        },
      ),
      requiredColorField: FieldConfig.color(
        key: requiredColorField,
        label: 'Color Picker',
        required: true,
        validationMessages: {
          ValidationMessage.required: (_) => 'Color selection is required.',
        },
      ),
      requiredDropdownField: FieldConfig.dropdown(
        key: requiredDropdownField,
        label: 'Select Country',
        required: true,
        items: [
          {'US': 'United States'},
          {'IN': 'India'},
          {'CA': 'Canada'},
        ],
        isSingleDropDown: true,
        validationMessages: {
          ValidationMessage.required: (_) => 'Country selection is required.',
        },
      ),
      requiredCheckboxField: FieldConfig.checkRadio<List<dynamic>>(
        key: requiredCheckboxField,
        label: 'Select Tech Stack',
        required: true,
        items: [
          {'FL': 'Flutter'},
          {'KT': 'Kotlin'},
          {'SW': 'Swift'},
          {'TS': 'TypeScript'},
        ],
        isSingleSelect: false,
        validationMessages: {
          ValidationMessage.required: (_) => 'At least one option must be selected.',
        },
      ),
      requiredDateField: FieldConfig.dateTime<String>(
        key: requiredDateField,
        label: 'Date Picker',
        required: true,
        mode: SmartPickerMode.dateOnly,
        dateFormat: 'yyyy-MM-dd',
        validationMessages: {
          ValidationMessage.required: (_) => 'Date selection is required.',
        },
      ),
      requiredDurationField: FieldConfig.duration(
        key: requiredDurationField,
        label: 'Duration Picker',
        required: true,
        validationMessages: {
          ValidationMessage.required: (_) => 'Duration selection is required.',
        },
      ),
    };

    initForm();

    // Disable all read-only fields initially
    formGroup.control(apiKeyField).markAsDisabled();
    formGroup.control(disabledEmojiField).markAsDisabled();
    formGroup.control(disabledColorField).markAsDisabled();
    formGroup.control(disabledDropdownField).markAsDisabled();
    formGroup.control(disabledMultiDropdownField).markAsDisabled();
    formGroup.control(disabledRadioField).markAsDisabled();
    formGroup.control(disabledCheckboxField).markAsDisabled();
    formGroup.control(disabledDateField).markAsDisabled();
    formGroup.control(disabledTimeField).markAsDisabled();
    formGroup.control(disabledDurationField).markAsDisabled();
  }
}

class FormFieldsScreen extends StatefulWidget {
  const FormFieldsScreen({super.key});

  @override
  State<FormFieldsScreen> createState() => _FormFieldsScreenState();
}

class _FormFieldsScreenState extends State<FormFieldsScreen> {
  late final DemoFormFields _form;
  Timer? _otpTimer;
  final ValueNotifier<int> _otpSecondsRemainingNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _form = DemoFormFields();
  }

  @override
  void dispose() {
    _otpTimer?.cancel();
    _otpSecondsRemainingNotifier.dispose();
    super.dispose();
  }

  void _startOtpTimer() {
    _otpTimer?.cancel();
    _otpSecondsRemainingNotifier.value = 60;
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpSecondsRemainingNotifier.value > 0) {
        _otpSecondsRemainingNotifier.value--;
      } else {
        _otpTimer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Fields Explorer'),
      ),
      body: _form.formGroupWrap(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacings.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Mandatory / Required Fields Card
              _buildSectionHeader(context, 'Mandatory & Required Fields', Icons.star_rate_rounded),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacings.spacingLarge),
                  child: Column(
                    children: [
                      _buildFieldSection(
                        context,
                        title: 'This is Enabled Username',
                        description: 'Default text field. Triggers validation if empty or under 4 characters.',
                        field: _form.buildWidget(DemoFormFields.usernameField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Email with Start & End Icons',
                        description: 'Email field with decorative prefix and suffix icons.',
                        field: _form.buildWidget(DemoFormFields.emailField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Password with Show/Hide Toggle',
                        description: 'Obscured password field displaying a show/hide toggle text button.',
                        field: _form.buildWidget(DemoFormFields.passwordField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is GitHub Handle with Success Validation',
                        description: 'Paints a green checkmark when the input handle is valid.',
                        field: _form.buildWidget(DemoFormFields.githubField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Required Emoji Picker',
                        description: 'Emoji selection is mandatory.',
                        field: _form.buildWidget(DemoFormFields.requiredEmojiField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Required Color Picker',
                        description: 'Color selection is mandatory.',
                        field: _form.buildWidget(DemoFormFields.requiredColorField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Required Single-Select Dropdown',
                        description: 'Country selection is mandatory.',
                        field: _form.buildWidget(DemoFormFields.requiredDropdownField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Required Checkbox List',
                        description: 'At least one tech stack option must be selected.',
                        field: _form.buildWidget(DemoFormFields.requiredCheckboxField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Required Date Picker',
                        description: 'Date selection is mandatory.',
                        field: _form.buildWidget(DemoFormFields.requiredDateField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Required Duration Picker',
                        description: 'Duration selection is mandatory.',
                        field: _form.buildWidget(DemoFormFields.requiredDurationField),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 2. Optional Fields Card
              _buildSectionHeader(context, 'Optional Fields', Icons.check_circle_outline_rounded),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacings.spacingLarge),
                  child: Column(
                    children: [
                      _buildFieldSection(
                        context,
                        title: 'This is Multi-line Description Field',
                        description: 'Description area that allows multi-line text input (maxLines: 3).',
                        field: _form.buildWidget(DemoFormFields.bioField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Enabled Emoji Picker',
                        description: 'Click to select a dynamic emoji character.',
                        field: _form.buildWidget(DemoFormFields.emojiField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Enabled Color Picker',
                        description: 'Click to open the theme color selector tool.',
                        field: _form.buildWidget(DemoFormFields.colorField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Enabled Single-Select Dropdown',
                        description: 'Single-option selection from a country list.',
                        field: _form.buildWidget(DemoFormFields.dropdownField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Enabled Multi-Select Dropdown',
                        description: 'Multi-option selection from a tech stack list.',
                        field: _form.buildWidget(DemoFormFields.multiDropdownField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Enabled Radio Group (Single-Select)',
                        description: 'Single-selection radio button list.',
                        field: _form.buildWidget(DemoFormFields.radioField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Enabled Checkbox List (Multi-Select)',
                        description: 'Multi-selection checkbox list.',
                        field: _form.buildWidget(DemoFormFields.checkboxField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Enabled Date Picker',
                        description: 'Calendar date picker field.',
                        field: _form.buildWidget(DemoFormFields.dateField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Enabled Time Picker',
                        description: 'Clock time selector field.',
                        field: _form.buildWidget(DemoFormFields.timeField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Enabled Duration Picker',
                        description: 'Scrollable duration selector field.',
                        field: _form.buildWidget(DemoFormFields.durationField),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Disabled & Read-Only Fields Card
              _buildSectionHeader(context, 'Disabled & Read-Only Fields', Icons.block_flipped),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacings.spacingLarge),
                  child: Column(
                    children: [
                      _buildFieldSection(
                        context,
                        title: 'This is Disabled API Key',
                        description: 'API key field rendered in a read-only state.',
                        field: _form.buildWidget(DemoFormFields.apiKeyField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Disabled Emoji Picker',
                        description: 'Emoji selection tool in a disabled state.',
                        field: _form.buildWidget(DemoFormFields.disabledEmojiField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Disabled Color Picker',
                        description: 'Theme color selector in a disabled state.',
                        field: _form.buildWidget(DemoFormFields.disabledColorField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Disabled Single-Select Dropdown',
                        description: 'Single-option country list dropdown in a disabled state.',
                        field: _form.buildWidget(DemoFormFields.disabledDropdownField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Disabled Multi-Select Dropdown',
                        description: 'Multi-option tech stack list dropdown in a disabled state.',
                        field: _form.buildWidget(DemoFormFields.disabledMultiDropdownField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Disabled Radio Group',
                        description: 'Radio button group in a disabled state.',
                        field: _form.buildWidget(DemoFormFields.disabledRadioField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Disabled Checkbox List',
                        description: 'Checkbox list in a disabled state.',
                        field: _form.buildWidget(DemoFormFields.disabledCheckboxField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Disabled Date Picker',
                        description: 'Calendar date picker in a disabled state.',
                        field: _form.buildWidget(DemoFormFields.disabledDateField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Disabled Time Picker',
                        description: 'Clock time selector in a disabled state.',
                        field: _form.buildWidget(DemoFormFields.disabledTimeField),
                      ),
                      const SizedBox(height: 24),
                      _buildFieldSection(
                        context,
                        title: 'This is Disabled Duration Picker',
                        description: 'Scrollable duration selector in a disabled state.',
                        field: _form.buildWidget(DemoFormFields.disabledDurationField),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 7. Form Actions
              _buildSectionHeader(context, 'Form Validation Controls', Icons.check_circle_outline_rounded),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacings.spacingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ReactiveFormConsumer(
                        builder: (context, form, child) {
                          final isValid = form.valid;
                          return Row(
                            children: [
                              Icon(
                                isValid ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                                color: isValid ? colorScheme.primary : colorScheme.error,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isValid ? 'Form status is valid' : 'Form contains invalid fields',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isValid ? colorScheme.primary : colorScheme.error,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      SmartPrimaryButton(
                        label: 'Validate & Submit Form',
                        onPressed: () async {
                          _form.markAllTouched();
                          if (_form.formGroup.valid) {
                            SmartSnackBars.show(
                              message: 'Success! Form inputs are valid.',
                              type: NotificationType.success,
                            );
                          } else {
                            SmartSnackBars.show(
                              message: 'Validation failed. Please check form errors.',
                              type: NotificationType.error,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      SmartPrimaryButton(
                        label: 'Reset Form Values',
                        isText: true,
                        onPressed: () async {
                          _form.reset();
                          SmartSnackBars.show(
                            message: 'Form fields successfully reset.',
                            type: NotificationType.info,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      SmartPrimaryButton(
                        label: 'Show OTP Verification Dialog',
                        onPressed: () async {
                          if (_otpSecondsRemainingNotifier.value == 0) {
                            SmartSnackBars.show(
                              message: 'Verification code sent to user@example.com!',
                              type: NotificationType.success,
                            );
                            _startOtpTimer();
                          }
                          final verified = await OtpDialog.show(
                            context,
                            email: 'user@example.com',
                            secondsRemainingNotifier: _otpSecondsRemainingNotifier,
                            onVerify: (otp) async {
                              await Future.delayed(const Duration(seconds: 2));
                              if (otp != '123456') {
                                throw Exception('Invalid OTP. Use code 123456.');
                              }
                            },
                            onResend: () async {
                              await Future.delayed(const Duration(milliseconds: 1500));
                              _startOtpTimer();
                            },
                          );
                          if (verified == true) {
                            SmartSnackBars.show(
                              message: 'OTP Verified successfully!',
                              type: NotificationType.success,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Divider(thickness: 1.2),
      ],
    );
  }

  Widget _buildFieldSection(
    BuildContext context, {
    required String title,
    required String description,
    required Widget field,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          description,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: field,
        ),
      ],
    );
  }
}

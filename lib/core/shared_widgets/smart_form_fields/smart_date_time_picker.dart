import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../core/theme/app_theme.dart';
import 'smart_form_field_theme.dart';

enum SmartPickerMode { dateOnly, timeOnly, dateAndTime }

/// **Form control types:**
/// - Single selection → `FormControl<String>` (ISO-formatted string)
/// - Multi selection  → `FormControl<List<String>>` (list of ISO-formatted strings)
///
/// **Parameters:**
/// - [mode] — date only, time only, or both.
/// - [isMultiSelection] — allow picking multiple values (shown as chips).
/// - [firstDate] / [lastDate] — date range constraints.
/// - [use24HourFormat] — 24h vs AM/PM for time picker.
/// - [dateFormat] / [timeFormat] — display format strings (uses `intl`).
class SmartDateTimePicker extends StatefulWidget {
  final String formControlName;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isGreenWarnNeed;
  final Map<String, ValidationMessageFunction>? validationMessages;
  final void Function(dynamic value)? onChanged;

  final SmartPickerMode mode;
  final bool isMultiSelection;

  /// Earliest selectable date (ignored when [mode] is [SmartPickerMode.timeOnly]).
  final DateTime? firstDate;

  /// Latest selectable date (ignored when [mode] is [SmartPickerMode.timeOnly]).
  final DateTime? lastDate;

  /// Initial date to show when the picker opens (defaults to today).
  final DateTime? initialDate;

  /// Initial time to show when the picker opens (defaults to now).
  final TimeOfDay? initialTime;

  /// Whether to use 24-hour format for the time picker.
  final bool use24HourFormat;

  /// Display format for dates. Defaults to null, which falls back to AppTheme.
  final String? dateFormat;

  /// Display format for times. Defaults to `'hh:mm a'` or `'HH:mm'`.
  final String? timeFormat;

  /// Optional custom date formatter callback.
  final String Function(DateTime)? dateCustomFormatter;

  /// Optional custom time formatter callback.
  final String Function(DateTime)? timeCustomFormatter;

  const SmartDateTimePicker({
    super.key,
    required this.formControlName,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.isGreenWarnNeed = false,
    this.validationMessages,
    this.onChanged,
    this.mode = SmartPickerMode.dateAndTime,
    this.isMultiSelection = false,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.initialTime,
    this.use24HourFormat = false,
    this.dateFormat,
    this.timeFormat,
    this.dateCustomFormatter,
    this.timeCustomFormatter,
  });

  @override
  State<SmartDateTimePicker> createState() => _SmartDateTimePickerState();
}

class _SmartDateTimePickerState extends State<SmartDateTimePicker> {
  final TextEditingController _textController = TextEditingController();
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

  // ── Formatting helpers ──────────────────────────────────────────────

  String _formatValue(String isoValue) {
    switch (widget.mode) {
      case SmartPickerMode.dateOnly:
        final dt = DateTime.tryParse(isoValue);
        if (dt == null) return isoValue;
        if (widget.dateFormat != null) return DateFormat(widget.dateFormat).format(dt);
        if (widget.dateCustomFormatter != null) return widget.dateCustomFormatter!(dt);
        return DateFormat('dd MMM yyyy').format(dt);

      case SmartPickerMode.timeOnly:
      // Stored as "HH:mm"
        final parts = isoValue.split(':');
        if (parts.length < 2) return isoValue;
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        final tod = TimeOfDay(hour: hour, minute: minute);
        final now = DateTime.now();
        final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
        if (widget.timeFormat != null) return DateFormat(widget.timeFormat).format(dt);
        if (widget.timeCustomFormatter != null) return widget.timeCustomFormatter!(dt);
        return DateFormat('hh:mm a').format(dt);

      case SmartPickerMode.dateAndTime:
        final dt = DateTime.tryParse(isoValue);
        if (dt == null) return isoValue;
        final dStr = widget.dateFormat != null
            ? DateFormat(widget.dateFormat).format(dt)
            : (widget.dateCustomFormatter != null
            ? widget.dateCustomFormatter!(dt)
            : DateFormat('dd MMM yyyy').format(dt));
        final tStr = widget.timeFormat != null
            ? DateFormat(widget.timeFormat).format(dt)
            : (widget.timeCustomFormatter != null
            ? widget.timeCustomFormatter!(dt)
            : DateFormat('hh:mm a').format(dt));
        return '$dStr  $tStr';
    }
  }

  IconData get _defaultIcon {
    switch (widget.mode) {
      case SmartPickerMode.dateOnly:
        return Icons.calendar_today_rounded;
      case SmartPickerMode.timeOnly:
        return Icons.more_time;
      case SmartPickerMode.dateAndTime:
        return Icons.event_rounded;
    }
  }

  // ── Multi-select helpers ────────────────────────────────────────────

  List<String> _parseMultiValues(dynamic raw) {
    if (raw is List) return raw.map((e) => e.toString()).toList();
    return [];
  }

  void _updateTextForMulti(List<String> values) {
    _textController.text = values.map(_formatValue).join(', ');
  }

  // ── Picker logic ───────────────────────────────────────────────────

  Future<String?> _pickSingleValue(
      BuildContext context,
      String? current,
      ) async {
    DateTime? pickedDate;
    TimeOfDay? pickedTime;

    final now = DateTime.now();
    final effectiveFirstDate =
        widget.firstDate ?? DateTime(now.year - 100, 1, 1);
    final effectiveLastDate =
        widget.lastDate ?? DateTime(now.year + 100, 12, 31);

    // ─── Date ────────────────────────────────────────────────────
    if (widget.mode != SmartPickerMode.timeOnly) {
      DateTime initialDate;
      if (current != null && DateTime.tryParse(current) != null) {
        initialDate = DateTime.parse(current);
      } else {
        initialDate = widget.initialDate ?? now;
      }
      // Clamp to range
      if (initialDate.isBefore(effectiveFirstDate)) {
        initialDate = effectiveFirstDate;
      }
      if (initialDate.isAfter(effectiveLastDate)) {
        initialDate = effectiveLastDate;
      }

      pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: effectiveFirstDate,
        lastDate: effectiveLastDate,
      );
      if (pickedDate == null) return null; // user cancelled
    }

    // ─── Time ────────────────────────────────────────────────────
    if (widget.mode != SmartPickerMode.dateOnly) {
      TimeOfDay initialTime;
      if (widget.mode == SmartPickerMode.timeOnly &&
          current != null &&
          current.contains(':')) {
        final parts = current.split(':');
        initialTime = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? now.hour,
          minute: int.tryParse(parts[1]) ?? now.minute,
        );
      } else if (current != null && DateTime.tryParse(current) != null) {
        final dt = DateTime.parse(current);
        initialTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
      } else {
        initialTime = widget.initialTime ?? TimeOfDay.now();
      }

      if (!context.mounted) return null;
      pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
        builder: AppTheme.instance.getTimeFormat() == '24h'
            ? (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        )
            : null,
      );
      if (pickedTime == null) return null; // user cancelled
    }

    // ─── Compose result ──────────────────────────────────────────
    switch (widget.mode) {
      case SmartPickerMode.dateOnly:
        return pickedDate!.toIso8601String();

      case SmartPickerMode.timeOnly:
        return '${pickedTime!.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';

      case SmartPickerMode.dateAndTime:
        final dt = DateTime(
          pickedDate!.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime!.hour,
          pickedTime.minute,
        );
        return dt.toIso8601String();
    }
  }

  // ── Build ──────────────────────────────────────────────────────────

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Multi-select branch
    if (widget.isMultiSelection) {
      return _buildMultiSelect(context);
    }
    // Single-select branch
    return _buildSingleSelect(context);
  }

  // ── Single selection ───────────────────────────────────────────────

  Widget _buildSingleSelect(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: ReactiveStatusListenableBuilder(
          formControlName: widget.formControlName,
          builder: (context, control, child) {
            final isValid = control.valid;
            return ReactiveFormField<String, String>(
              formControlName: widget.formControlName,
              validationMessages: widget.validationMessages,
              builder: (field) {
                _textController.text =
                field.value != null && field.value!.isNotEmpty
                    ? _formatValue(field.value!)
                    : '';

                final bool isControlDisabled = field.control.disabled;

                return TextFormField(
                  onTapOutside: (PointerDownEvent event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: _textController,
                  focusNode: _focusNode,
                  enabled: !isControlDisabled,
                  readOnly: true,
                  onTap: isControlDisabled
                      ? null
                      : () async {
                    field.control.markAsTouched();
                    final result = await _pickSingleValue(context, field.value);
                    if (result != null) {
                      field.didChange(result);
                      widget.onChanged?.call(result);
                    }
                  },
                  decoration: InputDecoration(
                    isDense: false,
                    labelText: widget.labelText,
                    prefixIcon: widget.prefixIcon,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.suffixIcon != null) widget.suffixIcon! else Icon(_defaultIcon),
                        if (widget.isGreenWarnNeed && isValid && control.value != null && (control.value as String).isNotEmpty)
                          Icon(Icons.check_circle, color: SmartFormFieldTheme.successColor),
                      ],
                    ),
                    errorText: field.errorText,
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
                );
              },
            );
          },
        ),
      ),
    );
  }

  // ── Multi selection ────────────────────────────────────────────────

  Widget _buildMultiSelect(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: ReactiveStatusListenableBuilder(
          formControlName: widget.formControlName,
          builder: (context, control, child) {
            final isValid = control.valid;
            return ReactiveFormField<List<String>, List<String>>(
              formControlName: widget.formControlName,
              validationMessages: widget.validationMessages,
              builder:
                  (ReactiveFormFieldState<List<String>, List<String>> field) {
                final values = _parseMultiValues(field.value);
                _updateTextForMulti(values);
                final bool isControlDisabled = field.control.disabled;

                // Build chip list
                final chips = values.asMap().entries.map((entry) {
                  final i = entry.key;
                  final v = entry.value;
                  return Padding(
                    key: ValueKey(v),
                    padding: const EdgeInsets.only(right: 4),
                    child: Chip(
                      backgroundColor: isControlDisabled
                          ? Theme.of(context).disabledColor.withValues(alpha: 0.12)
                          : null,
                      side: BorderSide(
                        width: 1,
                        color: isControlDisabled
                            ? Theme.of(context).disabledColor.withValues(alpha: 0.2)
                            : Theme.of(context).colorScheme.outline,
                      ),
                      label: Text(
                        _formatValue(v),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: isControlDisabled ? Theme.of(context).disabledColor : null,
                            ),
                      ),
                      deleteIcon: isControlDisabled ? null : const Icon(Icons.close, size: 16),
                      onDeleted: isControlDisabled
                          ? null
                          : () {
                        final updated = List<String>.from(values)
                          ..removeAt(i);
                        field.didChange(updated);
                        widget.onChanged?.call(updated);
                      },
                    ),
                  );
                }).toList();

                return TextFormField(
                  onTapOutside: (PointerDownEvent event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: _textController,
                  focusNode: _focusNode,
                  enabled: !isControlDisabled,
                  readOnly: true,
                  onTap: isControlDisabled
                      ? null
                      : () async {
                    field.control.markAsTouched();
                    final result = await _pickSingleValue(context, null);
                    if (result != null) {
                      if (!values.contains(result)) {
                        final updated = List<String>.from(values)
                          ..add(result);
                        field.didChange(updated);
                        widget.onChanged?.call(updated);
                      }
                    }
                  },
                  decoration:
                  InputDecoration(
                    isDense: false,
                    labelText: widget.labelText,
                    prefixIcon: widget.prefixIcon,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.suffixIcon != null) widget.suffixIcon! else Icon(_defaultIcon),
                        if (widget.isGreenWarnNeed && isValid && control.value != null && (control.value as List).isNotEmpty)
                          Icon(Icons.check_circle, color: SmartFormFieldTheme.successColor),
                      ],
                    ),
                    errorText: field.errorText,
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
                      borderRadius: BorderRadius.circular(
                        SmartFormFieldTheme.radius,
                      ),
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
                  ).copyWith(
                    prefix: chips.isNotEmpty
                        ? Padding(
                      padding: EdgeInsets.only(
                        right:
                        30.0 +
                            (widget.prefixIcon == null ? 0 : 35),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: chips),
                      ),
                    )
                        : null,
                  ),
                  showCursor: false,
                  enableInteractiveSelection: false,
                  cursorColor: Colors.transparent,
                  style: chips.isNotEmpty
                      ? const TextStyle(
                    color: Colors.transparent,
                    height: 0.0,
                  )
                      : null,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../smart_dialogs.dart';
import 'smart_buttons.dart';
import 'smart_form_field_theme.dart';

class SmartDropDown extends StatefulWidget {
  final String formControlName;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isGreenWarnNeed;
  final Map<String, ValidationMessageFunction>? validationMessages;
  final void Function(List<String> selectedItems)? onChanged;
  final List<Map<String, String>> items;
  final bool isSingleDropDown;
  final bool singleSelectHasDeselect;
  final List<String>? initialSelectedItems;
  final bool isVertical;
  final bool removeXButtonOnChip;
  final String? searchHintText;
  final String? noItemsText;
  final String? selectAllText;
  final String? deselectAllText;
  final String? saveText;
  final String? cancelText;
  final double? maxWidth;
  final String? dialogTitle;

  const SmartDropDown({
    super.key,
    required this.formControlName,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.isGreenWarnNeed = false,
    this.validationMessages,
    this.onChanged,
    required this.items,
    this.isSingleDropDown = false,
    this.singleSelectHasDeselect = false,
    this.initialSelectedItems,
    this.isVertical = false,
    this.removeXButtonOnChip = false,
    this.searchHintText,
    this.noItemsText,
    this.selectAllText,
    this.deselectAllText,
    this.saveText,
    this.cancelText,
    this.maxWidth = 450,
    this.dialogTitle,
  });

  @override
  State<SmartDropDown> createState() => _SmartDropDownState();
}

class _SmartDropDownState extends State<SmartDropDown> {
  late List<String> selectedItems;
  TextEditingController textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String _getValueFromKey(String key) {
    for (var map in widget.items) {
      if (map.containsKey(key)) {
        return map[key] ?? key;
      }
    }
    return key;
  }

  void _updateTextController() {
    textEditingController.text =
        selectedItems.map((key) => _getValueFromKey(key)).join(', ');
  }

  @override
  void initState() {
    super.initState();
    selectedItems = List<String>.from(widget.initialSelectedItems ?? []);
    _updateTextController();
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
    final primaryColor = Theme.of(context).colorScheme.primary;

    Widget content = Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: ReactiveStatusListenableBuilder(
        formControlName: widget.formControlName,
        builder: (context, control, child) {
          final isValid = control.valid;
          return ReactiveFormField<List<String>, List<String>>(
            formControlName: widget.formControlName,
            validationMessages: widget.validationMessages,
            builder: (ReactiveFormFieldState<List<String>, List<String>> field) {
              final values = field.value ?? [];
              final bool isControlDisabled = field.control.disabled;
              
              // Sync local state with field value if they differ
              if (values.length != selectedItems.length || 
                  !values.every((v) => selectedItems.contains(v))) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      selectedItems = List<String>.from(values);
                      _updateTextController();
                    });
                  }
                });
              }

              List<Widget> chipList = List.generate(
                selectedItems.length,
                    (index) {
                  final item = selectedItems[index];
                  return Padding(
                    key: ValueKey(item),
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
                      key: ValueKey('chip-$item'),
                      label: Text(
                        _getValueFromKey(item),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: isControlDisabled ? Theme.of(context).disabledColor : null,
                            ),
                      ),
                      deleteIcon: (widget.removeXButtonOnChip || isControlDisabled) ? null : const Icon(Icons.close, size: 16),
                      onDeleted: (widget.removeXButtonOnChip || isControlDisabled) ? null : () {
                        setState(() {
                          selectedItems.remove(item);
                          _updateTextController();

                          // Update the ReactiveForm state
                          field.didChange(
                            List<String>.from(selectedItems),
                          );

                          if (widget.onChanged != null) {
                            widget.onChanged!(selectedItems);
                          }
                        });
                      },
                    ),
                  );
                },
              ).toList();
              return TextFormField(
                onTapOutside: (PointerDownEvent event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: textEditingController,
                focusNode: _focusNode,
                enabled: !isControlDisabled,
                onTap: isControlDisabled
                    ? null
                    : () async {
                  field.control.markAsTouched();
                  final selected = await SmartDialogs.showCustom<Set<String>>(
                    context: context,
                    builder: (context) {
                      return MultiDropDownDialog(
                        items: widget.items,
                        selectedItems: selectedItems,
                        labelText: widget.labelText,
                        dialogTitle: widget.dialogTitle,
                        isSingleDropDown: widget.isSingleDropDown,
                        singleSelectHasDeselect: widget.singleSelectHasDeselect,
                        searchHintText: widget.searchHintText,
                        noItemsText: widget.noItemsText,
                        selectAllText: widget.selectAllText,
                        deselectAllText: widget.deselectAllText,
                        saveText: widget.saveText,
                        cancelText: widget.cancelText,
                      );
                    },
                  );
                  if (selected != null) {
                    setState(() {
                      selectedItems
                        ..clear()
                        ..addAll(selected);
                      _updateTextController();

                      // Update the ReactiveForm state
                      field.didChange(List<String>.from(selectedItems));

                      if (widget.onChanged != null) {
                        widget.onChanged!(selectedItems);
                      }
                    });
                  }
                },
                decoration: InputDecoration(
                  isDense: false,
                  prefixIcon: widget.prefixIcon,
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
                  prefix: Padding(
                    padding: EdgeInsets.only(
                      right: 30.0 + (widget.prefixIcon == null ? 0 : 35),
                    ),
                    child: widget.isVertical
                        ? SingleChildScrollView(
                      child: Wrap(children: chipList),
                    )
                        : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: chipList),
                    ),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.suffixIcon != null) widget.suffixIcon! else const Icon(Icons.keyboard_arrow_down_rounded, size: 24),
                      if (widget.isGreenWarnNeed && isValid && control.value != null && (control.value as List).isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.check_circle, color: SmartFormFieldTheme.successColor),
                        ),
                    ],
                  ),
                ),
                readOnly: true,
                showCursor: false,
                enableInteractiveSelection: false,
                cursorColor: Colors.transparent,
                style: const TextStyle(
                  color: Colors.transparent,
                  height: 0.0,
                ),
              );
            },
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

class MultiDropDownDialog extends StatefulWidget {
  final List<Map<String, String>> items;
  final List<String> selectedItems;
  final String? labelText;
  final String? dialogTitle;
  final bool isSingleDropDown;
  final bool singleSelectHasDeselect;

  final String? searchHintText;
  final String? noItemsText;
  final String? selectAllText;
  final String? deselectAllText;
  final String? saveText;
  final String? cancelText;

  const MultiDropDownDialog({
    super.key,
    required this.items,
    required this.selectedItems,
    this.labelText,
    this.dialogTitle,
    required this.isSingleDropDown,
    required this.singleSelectHasDeselect,
    this.searchHintText,
    this.noItemsText,
    this.selectAllText,
    this.deselectAllText,
    this.saveText,
    this.cancelText,
  });

  @override
  State<MultiDropDownDialog> createState() => _MultiDropDownDialogState();
}

class _MultiDropDownDialogState extends State<MultiDropDownDialog> {
  final Set<String> _tempSelectedItems = {};
  List<Map<String, String>> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();
  String? _selectedItemKey;

  @override
  void initState() {
    super.initState();
    _tempSelectedItems.addAll(widget.selectedItems);
    _filteredItems = widget.items;
    _searchController.addListener(_onSearchChanged);
    if (widget.isSingleDropDown && _tempSelectedItems.isNotEmpty) {
      _selectedItemKey = _tempSelectedItems.first;
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = widget.items.where((item) {
        if (item.values.isEmpty) return false;
        final itemValue = item.values.first;
        return itemValue.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final isAllFilteredSelected = _filteredItems.isNotEmpty &&
        _filteredItems.every((item) => item.keys.isNotEmpty && _tempSelectedItems.contains(item.keys.first));

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SmartFormFieldTheme.radius),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isLandscape ? 12 : 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: mediaQuery.size.height * 0.88,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Text(
                    widget.dialogTitle ?? 'Select ${widget.labelText ?? ''}',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),

              if (widget.items.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: TextField(
                    onTapOutside: (PointerDownEvent event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: widget.searchHintText ?? "Search...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SmartFormFieldTheme.radius),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),

              if (widget.items.isNotEmpty && !widget.isSingleDropDown) ...[
                CheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  visualDensity: const VisualDensity(vertical: -2),
                  value: isAllFilteredSelected,
                  title: Text(
                    isAllFilteredSelected
                        ? (widget.deselectAllText ?? "Deselect All")
                        : (widget.selectAllText ?? "Select All"),
                  ),
                  onChanged: (v) {
                    setState(() {
                      if (v != true) {
                        for (var item in _filteredItems) {
                          if (item.keys.isNotEmpty) {
                            _tempSelectedItems.remove(item.keys.first);
                          }
                        }
                      } else {
                        for (var item in _filteredItems) {
                          if (item.keys.isNotEmpty) {
                            _tempSelectedItems.add(item.keys.first);
                          }
                        }
                      }
                    });
                  },
                ),
                Divider(height: 1, color: theme.dividerColor),
              ],

              // Flexible scrollable area ensures list shrinks in landscape without hiding action buttons
              Flexible(
                child: widget.items.isEmpty
                    ? Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 40,
                              color: theme.disabledColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.noItemsText ?? 'No items available',
                              style: TextStyle(color: theme.disabledColor),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          final itemKey = item.keys.isNotEmpty ? item.keys.first : '';
                          final itemValue = item.values.isNotEmpty ? item.values.first : '';
                          if (!widget.isSingleDropDown) {
                            return CheckboxListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              visualDensity: const VisualDensity(vertical: -1.5),
                              value: _tempSelectedItems.contains(itemKey),
                              title: Text(itemValue),
                              onChanged: (v) {
                                setState(() {
                                  if (v == true) {
                                    _tempSelectedItems.add(itemKey);
                                  } else {
                                    _tempSelectedItems.remove(itemKey);
                                  }
                                });
                              },
                            );
                          } else {
                            final isSelected = _selectedItemKey == itemKey;
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              visualDensity: const VisualDensity(vertical: -1.5),
                              leading: Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: isSelected ? theme.colorScheme.primary : null,
                              ),
                              title: Text(itemValue),
                              onTap: () {
                                setState(() {
                                  if (widget.singleSelectHasDeselect &&
                                      (_selectedItemKey == itemKey)) {
                                    _selectedItemKey = null;
                                    _tempSelectedItems.clear();
                                  } else {
                                    _selectedItemKey = itemKey;
                                    _tempSelectedItems.clear();
                                    _tempSelectedItems.add(itemKey);
                                  }
                                });
                              },
                            );
                          }
                        },
                      ),
              ),

              const SizedBox(height: 8),

              // Action Buttons pinned at bottom
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    child: Text(
                      widget.cancelText ?? 'Cancel',
                      style: TextStyle(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white70
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SmartPrimaryButton(
                    height: 38,
                    width: 100,
                    onPressed: () async => Navigator.of(context).pop(_tempSelectedItems),
                    label: widget.saveText ?? 'Save',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

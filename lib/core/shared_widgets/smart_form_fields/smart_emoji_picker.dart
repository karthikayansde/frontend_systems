import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../core/constants/app_spacings.dart';
import 'smart_form_field_theme.dart';

class SmartEmojiPickerField extends StatefulWidget {
  final String formControlName;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isGreenWarnNeed;
  final Map<String, ValidationMessageFunction>? validationMessages;
  final void Function(String? selectedEmoji)? onChanged;

  const SmartEmojiPickerField({
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
  State<SmartEmojiPickerField> createState() => _SmartEmojiPickerFieldState();
}

class _SmartEmojiPickerFieldState extends State<SmartEmojiPickerField> {
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
            return ReactiveFormField<String, String>(
              formControlName: widget.formControlName,
              validationMessages: widget.validationMessages,
              builder: (ReactiveFormFieldState<String, String> field) {
                final String currentEmoji = field.value ?? '';
                textEditingController.text = currentEmoji;
                final bool isControlDisabled = field.control.disabled;
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
                    final selected = await _showEmojiPicker(
                      context,
                      currentEmoji: currentEmoji,
                    );
                    if (selected != null) {
                      field.didChange(selected);
                      if (widget.onChanged != null) {
                        widget.onChanged!(selected);
                      }
                    }
                  },
                  decoration: InputDecoration(
                    isDense: false,
                    prefixIcon: widget.prefixIcon,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.suffixIcon != null) widget.suffixIcon!,
                        if (widget.isGreenWarnNeed && isValid && control.value != null && (control.value as String).isNotEmpty)
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
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 24,
                      ),
                );
              },
            );
          },
        ),
      ),
    );
  }
  /// Common Dialog for Emoji Selection
  Future<String?> _showEmojiPicker(
      BuildContext context, {
        String? currentEmoji,
      }) async
  {
    List<CategoryEmoji>? categories;
    List<Emoji>? allEmojis;
    // bool isLoadingEmojis = false;

    // Load emojis once
    Future<void> loadEmojis() async {
      try {
        final List<CategoryEmoji> filtered =
        await EmojiPickerUtils().filterUnsupported(emojiSetEnglish);
        categories = filtered;
        allEmojis = filtered.expand((c) => c.emoji).toList();
      } catch (e) {
        debugPrint("Error loading emojis: $e");
      }
    }

    await loadEmojis();

    if (!context.mounted) return null;

    String searchQuery = '';
    Category? selectedCategory;
    String? selectedSkinTone;

    return showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            List<Emoji> filteredEmojis;
            if (searchQuery.isNotEmpty) {
              filteredEmojis = allEmojis!
                  .where((e) => e.name.toLowerCase().contains(searchQuery.toLowerCase()))
                  .toList();
            } else if (selectedCategory != null) {
              filteredEmojis = categories!
                  .firstWhere((c) => c.category == selectedCategory)
                  .emoji;
            } else {
              filteredEmojis = allEmojis!;
            }

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SmartFormFieldTheme.radius)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                padding: const EdgeInsets.all(AppSpacings.spacingLarge),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select Emoji',
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

                    // Search Bar
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search emojis...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      onChanged: (val) {
                        setDialogState(() {
                          searchQuery = val;
                        });
                      },
                    ),
                    const SizedBox(height: 8),

                    // Skin Tones
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSkinToneOption(context, null, selectedSkinTone, (tone) {
                            setDialogState(() => selectedSkinTone = tone);
                          }),
                          ...SkinTone.values.map((tone) => _buildSkinToneOption(
                            context,
                            tone,
                            selectedSkinTone,
                                (t) => setDialogState(() => selectedSkinTone = t),
                          )),
                        ],
                      ),
                    ),

                    // Categories
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _categoryTab(context, null, "All", Icons.apps_rounded, selectedCategory, searchQuery, (cat) {
                            setDialogState(() {
                              selectedCategory = cat;
                              searchQuery = '';
                            });
                          }),
                          _categoryTab(context, Category.SMILEYS, "Smileys", Icons.sentiment_satisfied_alt_rounded, selectedCategory, searchQuery, (cat) {
                            setDialogState(() {
                              selectedCategory = cat;
                              searchQuery = '';
                            });
                          }),
                          _categoryTab(context, Category.ANIMALS, "Animals", Icons.pets_rounded, selectedCategory, searchQuery, (cat) {
                            setDialogState(() {
                              selectedCategory = cat;
                              searchQuery = '';
                            });
                          }),
                          _categoryTab(context, Category.FOODS, "Foods", Icons.restaurant_rounded, selectedCategory, searchQuery, (cat) {
                            setDialogState(() {
                              selectedCategory = cat;
                              searchQuery = '';
                            });
                          }),
                          _categoryTab(context, Category.ACTIVITIES, "Activities", Icons.sports_basketball_rounded, selectedCategory, searchQuery, (cat) {
                            setDialogState(() {
                              selectedCategory = cat;
                              searchQuery = '';
                            });
                          }),
                          _categoryTab(context, Category.TRAVEL, "Travel", Icons.flight_takeoff_rounded, selectedCategory, searchQuery, (cat) {
                            setDialogState(() {
                              selectedCategory = cat;
                              searchQuery = '';
                            });
                          }),
                          _categoryTab(context, Category.OBJECTS, "Objects", Icons.lightbulb_outline_rounded, selectedCategory, searchQuery, (cat) {
                            setDialogState(() {
                              selectedCategory = cat;
                              searchQuery = '';
                            });
                          }),
                          _categoryTab(context, Category.SYMBOLS, "Symbols", Icons.euro_symbol_rounded, selectedCategory, searchQuery, (cat) {
                            setDialogState(() {
                              selectedCategory = cat;
                              searchQuery = '';
                            });
                          }),
                          _categoryTab(context, Category.FLAGS, "Flags", Icons.flag_rounded, selectedCategory, searchQuery, (cat) {
                            setDialogState(() {
                              selectedCategory = cat;
                              searchQuery = '';
                            });
                          }),
                        ],
                      ),
                    ),
                    const Divider(),

                    // Grid
                    Expanded(child:
                    categories == null
                        ? const Center(child: CircularProgressIndicator())
                        : filteredEmojis.isEmpty
                        ? const Center(child: Text("No emojis found"))
                        :
                    CustomScrollView(
                        slivers:[ SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                final baseEmoji = filteredEmojis[index];
                                final displayEmoji = (selectedSkinTone != null && baseEmoji.hasSkinTone)
                                    ? EmojiPickerUtils().applySkinTone(baseEmoji, selectedSkinTone!)
                                    : baseEmoji;

                                return InkWell(
                                  onTap: () => Navigator.pop(context, displayEmoji.emoji),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Center(
                                    child: Text(
                                      displayEmoji.emoji,
                                      style: const TextStyle(fontSize: 28),
                                    ),
                                  ),
                                );
                              },
                              childCount: filteredEmojis.length,
                            ),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                          ),
                        ),]
                    ),)
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- Internal Helpers ---

  static Widget _categoryTab(
      BuildContext context,
      Category? category,
      String label,
      IconData icon,
      Category? selectedCategory,
      String searchQuery,
      Function(Category?) onSelected,
      )
  {
    final bool isSelected = selectedCategory == category && searchQuery.isEmpty;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        avatar: Icon(icon, size: 16, color: isSelected ? Colors.white : null),
        selected: isSelected,
        onSelected: (selected) => onSelected(category),
        selectedColor: Theme.of(context).colorScheme.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
    );
  }

  static Widget _buildSkinToneOption(
      BuildContext context,
      String? tone,
      String? selectedSkinTone,
      Function(String?) onTap,
      )
  {
    final bool isSelected = selectedSkinTone == tone;
    const String previewBase = '👍';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () => onTap(tone),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).cardColor,
            border: Border.all(
              color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              tone == null ? previewBase : EmojiPickerUtils().applySkinTone(Emoji(previewBase, ''), tone).emoji,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

}
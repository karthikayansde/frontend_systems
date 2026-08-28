import 'package:flutter/services.dart';

/// A utility class to provide common TextInputFormatter lists for various input fields.
class AppInputFormatters {
  // --- Common Deny Patterns ---
  // These are characters that are typically NOT desired in most text fields,
  // especially for names, general text, etc.

  /// Denies common Latin accented characters (e.g., from European languages).
  /// These are already ranges, safe for direct inclusion in a character class.
  static const String _latinAccentedChars = r'À-ÖØ-öø-ÿ';

  /// Denies specific Latin extended characters with diacritics, often used in transliteration.
  /// These are already ranges, safe for direct inclusion in a character class.
  static const String _latinExtendedChars = r'ÆĒṬÑŪĪŌḤṄḌŚĀṢṆṀæēṭñūīōḥṅḍśāṣṇṁ';

  /// Denies common symbols, including special characters and some punctuation.
  /// Important: Inside a character class `[]`, only `^`, `-`, `]`, `\` have special meaning.
  /// Others like `!@#$%^&*()` don't need escaping.
  /// We need to escape `\` itself, `[`, `]`, `-`.
  static const String _commonSymbols = r'!@#$%^&*()_+={}\[\]:;<>,?~\\/\-"\'; // Escaped `[`, `]`, `\`, `-`, added single/double quotes at the end

  /// Denies a wide range of emojis and some obscure Unicode symbols.
  /// We convert these to individual characters or specific ranges safe for a combined character class.
  /// The original `[\u2000-\u3300]` etc. are themselves character classes and cannot be nested.
  /// We need to express them as raw parts of the combined character class.
  /// For emojis, Dart's `RegExp` does not fully support all Unicode properties like `\p{Emoji}` directly.
  /// The provided ranges are a good starting point but can be very broad.
  /// I'm including the raw unicode ranges as individual parts of the final regex.
  /// **Note:** `\ud83c[\ud000-\udfff]\ud83d[\ud000-\udfff]\ud83e[\ud000-\udfff]` are surrogate pairs.
  /// For `FilteringTextInputFormatter.deny`, it's often more practical to deny by general category
  /// or specific problematic ranges rather than trying to match full surrogate pairs.
  /// Let's simplify this for the character class.
  static const String _emojisAndObscureSymbolsChars =
      r'\u00a9\u00ae' // Copyright, Registered
      r'\u2000-\u200B\u200C\u200D' // General Punctuation (some zero width joiners, non-joiners)
      r'\u200E-\u200F\u2028-\u2029\u202F\u205F\u3000' // More spaces, line/paragraph separators
      r'\u2100-\u214F' // Letterlike Symbols
      r'\u2190-\u21FF' // Arrows
      r'\u2300-\u23FF' // Miscellaneous Technical
      r'\u2400-\u243F' // Control Pictures
      r'\u2440-\u245F' // Optical Character Recognition
      r'\u2500-\u257F' // Box Drawing
      r'\u2580-\u259F' // Block Elements
      r'\u25A0-\u25FF' // Geometric Shapes
      r'\u2600-\u26FF' // Miscellaneous Symbols (many common emojis are here)
      r'\u2700-\u27BF' // Dingbats (more common emojis)
      r'\u2B00-\u2BFF' // Miscellaneous Symbols and Arrows
      r'\u2E80-\u2FFF' // CJK Radicals, Ideograph Description Chars
      r'\u3000-\u303F' // CJK Symbols and Punctuation
      r'\u3040-\u309F' // Hiragana
      r'\u30A0-\u30FF' // Katakana
      r'\u3100-\u312F' // Bopomofo
      r'\u3130-\u318F' // Hangul Compatibility Jamo
      r'\u3190-\u319F' // Kanbun
      r'\u31A0-\u31BF' // Bopomofo Extended
      r'\u31F0-\u31FF' // Katakana Phonetic Extensions
      r'\u3200-\u32FF' // Enclosed CJK Letters and Months
      r'\u3300-\u33FF' // CJK Compatibility
      r'\uFE00-\uFE0F' // Variation Selectors (important for emoji appearance)
      r'\uFEFF'       // Zero Width No-Break Space (BOM)
      r'\uFFFD'       // Replacement Character
      r'\uFFFC'       // Object Replacement Character
  // Simplified approach for common emoji blocks (surrogate pairs are tricky for single char class deny)
  // These ranges cover many common emojis.
      r'\uD800-\uDBFF\uDC00-\uDFFF'; // Basic BMP Private Use Area, high and low surrogates
  // This is a broad stroke for "obscure Unicode"

  // --- Specific Allow Patterns ---
  /// Unicode range for Tamil script characters.
  /// This range `\u0B80-\u0BFF` covers the base characters and most combining characters.
  /// The dot on top (Pulli/மெய்) is a combining character. Ensure your font supports it.
  static const String _tamilChars = r'\u0B80-\u0BFF'; // This is equivalent to அ-ஔஃக-ஹ

  /// Blocks a predefined set of unwanted characters.
  /// We combine all deny patterns into a single character class.
  static final RegExp _globalDenyRegExp = RegExp(
    '[$_latinAccentedChars$_latinExtendedChars$_commonSymbols$_emojisAndObscureSymbolsChars]',
    unicode: true, // Crucial for correct handling of wider Unicode ranges
  );

  // --- Public Functions Based on Your Request ---

  /// Formatter for fields allowing only English and Tamil letters.
  /// Optionally limits the length of the input.
  static List<TextInputFormatter> onlyWords({int? length}) {
    final List<TextInputFormatter> formatters = [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z' '$_tamilChars]', unicode: true)),
      FilteringTextInputFormatter.deny(_globalDenyRegExp),
    ];
    if (length != null) {
      formatters.add(LengthLimitingTextInputFormatter(length));
    }
    return formatters;
  }

  /// Formatter for fields allowing only English and Tamil letters, and spaces.
  /// Optionally limits the length of the input.
  static List<TextInputFormatter> onlyWordsAndSpace({int? length}) {
    final List<TextInputFormatter> formatters = [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s' '$_tamilChars]', unicode: true)),
      FilteringTextInputFormatter.deny(_globalDenyRegExp),
    ];
    if (length != null) {
      formatters.add(LengthLimitingTextInputFormatter(length));
    }
    return formatters;
  }

  /// Formatter for fields allowing only digits.
  /// Optionally limits the length of the input.
  static List<TextInputFormatter> onlyDigits({int? length}) {
    final List<TextInputFormatter> formatters = [
      FilteringTextInputFormatter.digitsOnly,
      // While digitsOnly is strict, adding globalDeny ensures no unwanted unicode "digit-like" chars slip through.
      FilteringTextInputFormatter.deny(_globalDenyRegExp),
    ];
    if (length != null) {
      formatters.add(LengthLimitingTextInputFormatter(length));
    }
    return formatters;
  }

  /// Formatter for fields allowing English and Tamil letters, digits, and spaces.
  /// Optionally limits the length of the input.
  static List<TextInputFormatter> onlyWordsDigitsAndSpace({int? length}) {
    final List<TextInputFormatter> formatters = [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s' '$_tamilChars]', unicode: true)),
      FilteringTextInputFormatter.deny(_globalDenyRegExp),
    ];
    if (length != null) {
      formatters.add(LengthLimitingTextInputFormatter(length));
    }
    return formatters;
  }
  static List<TextInputFormatter> onlyWordsDigitsSpaceAndSpecial({int? length}) {
    final List<TextInputFormatter> formatters = [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s' '$_tamilChars]', unicode: true)),
    ];
    if (length != null) {
      formatters.add(LengthLimitingTextInputFormatter(length));
    }
    return formatters;
  }

  /// Formatter for fields allowing English and Tamil letters, and digits.
  /// Optionally limits the length of the input.
  static List<TextInputFormatter> onlyWordsAndDigits({int? length}) {
    final List<TextInputFormatter> formatters = [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9' '$_tamilChars]', unicode: true)),
      FilteringTextInputFormatter.deny(_globalDenyRegExp),
    ];
    if (length != null) {
      formatters.add(LengthLimitingTextInputFormatter(length));
    }
    return formatters;
  }

  /// Formatter for fields allowing only digits and a single decimal point.
  /// Optionally limits the total length, minimum/maximum value, and decimal precision.
  static List<TextInputFormatter> onlyDigitsWithDecimal({
    int? length,
    double? min,
    double? max,
    int? decimalPrecision,
  }) {
    return [
      TextInputFormatter.withFunction((oldValue, newValue) {
        final text = newValue.text;

        // 1. Allow empty string (so they can clear it)
        if (text.isEmpty) {
          return newValue;
        }

        // 2. Enforce character length limit (if length is specified)
        if (length != null && text.length > length) {
          return oldValue;
        }

        // 3. Regexp to only allow digits, a single decimal point, and an optional negative sign
        final regExp = RegExp(r'^-?\d*\.?\d*$');
        if (!regExp.hasMatch(text)) {
          return oldValue;
        }

        // 4. Validate decimal precision (digits after the decimal point)
        if (decimalPrecision != null && text.contains('.')) {
          final decimalPart = text.substring(text.indexOf('.') + 1);
          if (decimalPart.length > decimalPrecision) {
            return oldValue;
          }
        }

        // 5. Parse value for range checks
        final doubleValue = double.tryParse(text);
        if (doubleValue != null) {
          // Validate max limit
          if (max != null && doubleValue > max) {
            return oldValue;
          }

          // Validate min limit by checking the maximum possible value we can ever reach.
          // If the maximum possible value we can make by appending digits is less than the minimum, block it.
          // We explicitly allow temporary prefix inputs like '0', '.', '0.', and negative counterparts.
          if (min != null) {
            if (text == '0' || text == '.' || text == '0.' ||
                text == '-' || text == '-0' || text == '-.' || text == '-0.') {
              return newValue;
            }

            double maxValuePossible;
            if (text.startsWith('-')) {
              // For negative numbers, appending digits or dots decreases the value,
              // so the maximum possible value is the current value itself.
              maxValuePossible = double.tryParse(text) ?? double.negativeInfinity;
            } else {
              // Positive numbers
              if (text.contains('.')) {
                final parts = text.split('.');
                final integerPart = parts[0].isEmpty ? '0' : parts[0];
                final decimalPart = parts.length > 1 ? parts[1] : '';
                if (decimalPrecision != null) {
                  final remainingDecimals = decimalPrecision - decimalPart.length;
                  maxValuePossible = double.tryParse('$integerPart.$decimalPart${'9' * remainingDecimals}') ?? doubleValue;
                } else {
                  final intVal = double.tryParse(integerPart) ?? 0.0;
                  maxValuePossible = intVal + 1.0;
                }
              } else {
                maxValuePossible = double.infinity;
              }
            }

            if (maxValuePossible < min) {
              return oldValue;
            }
          }
        }

        return newValue;
      })
    ];
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/app_spacings.dart';
import 'smart_form_field_theme.dart';

class SmartPrimaryButton extends StatefulWidget {
  final String label;
  final Future<void> Function()? onPressed;
  final bool autoLoading;
  final bool isLoading; // Only respected when autoLoading = false
  final IconData? icon;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final bool isDisable;
  final bool clearFocus;
  final bool isOutlined;
  final bool isText;
  final String? heroTag;

  SmartPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.autoLoading = false,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 48,
    this.backgroundColor,
    this.isDisable = false,
    this.clearFocus = false,
    this.isOutlined = false,
    this.isText = false,
    this.heroTag,
  }) {
    assert(
      !(autoLoading && isLoading),
      'Do not use both autoLoading and isLoading together.',
    );
  }

  @override
  State<SmartPrimaryButton> createState() => _SmartPrimaryButtonState();
}

class _SmartPrimaryButtonState extends State<SmartPrimaryButton> {
  bool _internalLoading = false;

  // Resolves which loading state to show:
  // - autoLoading=true  → use internal _internalLoading
  // - autoLoading=false → use parent-controlled widget.isLoading
  bool get _effectiveLoading =>
      widget.autoLoading ? _internalLoading : widget.isLoading;

  Future<void> _handlePress() async {
    if (widget.clearFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }

    if (widget.autoLoading) {
      setState(() => _internalLoading = true);
      try {
        await widget.onPressed?.call();
      } finally {
        // Always reset loading even if onPressed throws
        if (mounted) setState(() => _internalLoading = false);
      }
    } else {
      await widget.onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveBackgroundColor =
        widget.backgroundColor ?? theme.colorScheme.primary;
    // Compute high-contrast text color dynamically based on background luminance
    final contrastColor = effectiveBackgroundColor.computeLuminance() < 0.45
        ? Colors.white
        : Colors.black87;

    // For outlined or text buttons, if the background/seed color is too dark in dark mode,
    // ensure text color has sufficient luminance against dark surfaces.
    final Color effectiveTextColor;
    if (widget.isOutlined || widget.isText) {
      if (isDark && effectiveBackgroundColor.computeLuminance() < 0.35) {
        effectiveTextColor = const Color(0xFFD0BCFF);
      } else {
        effectiveTextColor = effectiveBackgroundColor;
      }
    } else {
      effectiveTextColor = contrastColor;
    }

    final bool isButtonDisabled =
        _effectiveLoading || widget.isDisable || widget.onPressed == null;

    final borderRadius = BorderRadius.circular(SmartFormFieldTheme.radius);
    final shape = RoundedRectangleBorder(borderRadius: borderRadius);

    final disabledFg = (widget.isOutlined || widget.isText)
        ? effectiveTextColor.withValues(alpha: 0.45)
        : contrastColor.withValues(alpha: 0.65);

    final horizontalPadding =
        (widget.width != null && widget.width! < 130) ? 12.0 : 20.0;

    final buttonStyle = widget.isText
        ? TextButton.styleFrom(
            foregroundColor: effectiveTextColor,
            disabledForegroundColor: disabledFg,
            shape: shape,
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: 8),
          )
        : widget.isOutlined
            ? OutlinedButton.styleFrom(
                foregroundColor: effectiveTextColor,
                disabledForegroundColor: disabledFg,
                side: BorderSide(
                  color: isButtonDisabled
                      ? effectiveTextColor.withValues(alpha: 0.3)
                      : effectiveTextColor,
                ),
                shape: shape,
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              )
            : ElevatedButton.styleFrom(
                backgroundColor: effectiveBackgroundColor,
                foregroundColor: effectiveTextColor,
                disabledBackgroundColor:
                    effectiveBackgroundColor.withValues(alpha: 0.35),
                disabledForegroundColor: disabledFg,
                shape: shape,
                elevation: 2,
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              );

    final textColor = isButtonDisabled ? disabledFg : effectiveTextColor;

    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(widget.icon, size: 20, color: textColor),
          ),
        Flexible(
          child: Text(
            widget.label,
            style: theme.textTheme.titleMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (_effectiveLoading)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(textColor),
              ),
            ),
          ),
      ],
    );

    final Widget button = SizedBox(
      width: widget.width ?? (widget.isText ? null : double.infinity),
      height: widget.isText ? null : widget.height,
      child: widget.isText
          ? TextButton(
              onPressed: isButtonDisabled ? null : _handlePress,
              style: buttonStyle,
              child: child,
            )
          : widget.isOutlined
              ? OutlinedButton(
                  onPressed: isButtonDisabled ? null : _handlePress,
                  style: buttonStyle,
                  child: child,
                )
              : ElevatedButton(
                  onPressed: isButtonDisabled ? null : _handlePress,
                  style: buttonStyle,
                  child: child,
                ),
    );

    if (widget.heroTag != null) {
      return Hero(
        tag: widget.heroTag!,
        child: button,
      );
    }

    return button;
  }
}

//----------------------------------------------------------------------------------------------------------

class StyledIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double iconSize;
  final double? buttonSize;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? iconColor;
  final EdgeInsets? padding;
  final bool isOutlined;
  const StyledIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconSize = 24,
    this.buttonSize = AppSpacings.iconExtraLarge,
    this.borderRadius = AppSpacings.radiusSmall,
    this.backgroundColor,
    this.iconColor,
    this.padding,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: isOutlined
            ? Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: Icon(
              icon,
              color: iconColor ?? Theme.of(context).textTheme.bodyLarge!.color,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}

//----------------------------------------------------------------------------------------------------------

class SmartFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final String? heroTag;
  final Color? backgroundColor;
  final Widget child;
  const SmartFAB({
    super.key,
    required this.onPressed,
    required this.heroTag,
    this.backgroundColor,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      child: child,
    );
  }
}

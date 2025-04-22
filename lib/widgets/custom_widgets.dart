import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Image? image;
  final IconData? icon;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.image,
    this.width,
    this.height = 50.0,
    this.backgroundColor,
    this.icon,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isOutlined) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? theme.colorScheme.primary,
            side: BorderSide(
              color: textColor ?? theme.colorScheme.primary,
              width: 1.5,
            ),
          ),
          child: _buildButtonContent(context),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.colorScheme.primary,
          foregroundColor: textColor ?? Colors.white,
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return SpinKitThreeBounce(
        color: isOutlined
            ? (textColor ?? Theme.of(context).colorScheme.primary)
            : (textColor ?? Colors.white),
        size: 24.0,
      );
    }

    if (image != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image!,
          // Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.elevation = 2.0,
    this.onTap,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: elevation,
      color: backgroundColor ?? theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius:
            borderRadius ?? BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            borderRadius ?? BorderRadius.circular(AppTheme.borderRadiusMedium),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.focusNode,
    this.onEditingComplete,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class CustomImageView extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CustomImageView({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget image;

    if (imageUrl.startsWith('http')) {
      image = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) =>
            placeholder ??
            Center(
              child: SpinKitFadingCircle(
                color: theme.colorScheme.primary,
                size: 30.0,
              ),
            ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            Center(
              child: Icon(
                Icons.error_outline,
                color: theme.colorScheme.error,
                size: 30.0,
              ),
            ),
      );
    } else {
      // Assume it's an asset image
      image = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ??
            Center(
              child: Icon(
                Icons.error_outline,
                color: theme.colorScheme.error,
                size: 30.0,
              ),
            ),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }
}

class CustomDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final double indent;
  final double endIndent;
  final Color? color;

  const CustomDivider({
    super.key,
    this.height = 16.0,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color ?? Theme.of(context).dividerColor,
    );
  }
}

class CustomLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const CustomLoadingIndicator({
    super.key,
    this.size = 40.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCircle(
        color: color ?? Theme.of(context).colorScheme.primary,
        size: size,
      ),
    );
  }
}

class CustomBadge extends StatelessWidget {
  final Widget child;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry padding;
  final Alignment alignment;

  const CustomBadge({
    super.key,
    required this.child,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.padding = const EdgeInsets.all(4.0),
    this.alignment = Alignment.topRight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor ?? theme.colorScheme.error,
              borderRadius: BorderRadius.circular(12.0),
            ),
            constraints: const BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isSelected;

  const CustomChip({
    super.key,
    required this.label,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onTap != null ? (_) => onTap!() : null,
      backgroundColor: backgroundColor ?? theme.chipTheme.backgroundColor,
      selectedColor: backgroundColor != null
          ? backgroundColor!.withOpacity(0.7)
          : theme.colorScheme.primary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected
            ? (textColor ?? theme.colorScheme.primary)
            : (textColor ?? theme.textTheme.bodyMedium?.color),
      ),
      avatar: icon != null
          ? Icon(
              icon,
              size: 16.0,
              color: isSelected
                  ? (textColor ?? theme.colorScheme.primary)
                  : (textColor ?? theme.textTheme.bodyMedium?.color),
            )
          : null,
    );
  }
}

class CustomEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onActionPressed;
  final String? actionText;

  const CustomEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.onActionPressed,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80.0,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            if (onActionPressed != null && actionText != null) ...[
              const SizedBox(height: 24.0),
              CustomButton(
                  text: actionText!,
                  onPressed: onActionPressed!,
                  icon: Icons.refresh),
            ],
          ],
        ),
      ),
    );
  }
}

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60.0,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Error Occurred',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24.0),
              CustomButton(
                text: 'Retry',
                onPressed: onRetry!,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

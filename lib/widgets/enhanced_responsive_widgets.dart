import 'package:flutter/material.dart';
import '../utils/responsive_design_system.dart';
import '../theme/app_theme.dart';

class ResponsiveScaffold extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final bool resizeToAvoidBottomInset;
  final bool extendBodyBehindAppBar;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;

  const ResponsiveScaffold({
    super.key,
    required this.title,
    this.actions = const [],
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.resizeToAvoidBottomInset = true,
    this.extendBodyBehindAppBar = false,
    this.backgroundColor,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: ResponsiveDesignSystem.isDesktop(context) ? null : drawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      backgroundColor: backgroundColor,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      centerTitle: true,
      elevation: AppTheme.elevationMedium,
    );
  }

  Widget _buildBody(BuildContext context) {
    if (ResponsiveDesignSystem.isDesktop(context) && drawer != null) {
      return Row(
        children: [
          // Side drawer for desktop
          SizedBox(
            width: 250,
            child: drawer!,
          ),
          // Main content
          Expanded(
            child: body,
          ),
        ],
      );
    } else {
      return body;
    }
  }
}

class ResponsiveListView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? itemExtent;
  final Widget? separator;

  const ResponsiveListView({
    super.key,
    required this.children,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.controller,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.itemExtent,
    this.separator,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: ResponsiveDesignSystem.getHorizontalPadding(context),
          vertical: ResponsiveDesignSystem.getVerticalPadding(context),
        );

    if (separator != null) {
      return ListView.separated(
        padding: responsivePadding,
        shrinkWrap: shrinkWrap,
        physics: physics,
        controller: controller,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
        separatorBuilder: (context, index) => separator!,
      );
    } else {
      return ListView.builder(
        padding: responsivePadding,
        shrinkWrap: shrinkWrap,
        physics: physics,
        controller: controller,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        itemExtent: itemExtent,
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      );
    }
  }
}

class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double spacing;
  final double runSpacing;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final int? crossAxisCount;
  final double? childAspectRatio;

  const ResponsiveGridView({
    super.key,
    required this.children,
    this.padding,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.shrinkWrap = false,
    this.physics,
    this.controller,
    this.crossAxisCount,
    this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: ResponsiveDesignSystem.getHorizontalPadding(context),
          vertical: ResponsiveDesignSystem.getVerticalPadding(context),
        );

    final columns = crossAxisCount ?? ResponsiveDesignSystem.getGridColumns(context);
    final aspectRatio = childAspectRatio ?? 1.0;

    return GridView.builder(
      padding: responsivePadding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      controller: controller,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final Color? color;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.color,
    this.alignment,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: ResponsiveDesignSystem.getHorizontalPadding(context),
          vertical: ResponsiveDesignSystem.getVerticalPadding(context),
        );

    final responsiveWidth = width ?? ResponsiveDesignSystem.getContainerWidth(context);

    return Container(
      width: responsiveWidth,
      height: height,
      padding: responsivePadding,
      margin: margin,
      decoration: decoration,
      color: color,
      alignment: alignment,
      constraints: constraints,
      child: child,
    );
  }
}

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool? softWrap;
  final TextScaler? textScaler;
  final TextType textType;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.textScaler,
    this.textType = TextType.body,
  });

  const ResponsiveText.headlineLarge(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.textScaler,
  }) : textType = TextType.headlineLarge;

  const ResponsiveText.headlineMedium(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.textScaler,
  }) : textType = TextType.headlineMedium;

  const ResponsiveText.bodyLarge(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.textScaler,
  }) : textType = TextType.bodyLarge;

  const ResponsiveText.bodyMedium(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.textScaler,
  }) : textType = TextType.bodyMedium;

  @override
  Widget build(BuildContext context) {
    TextStyle? baseStyle;
    double fontSize;

    switch (textType) {
      case TextType.headlineLarge:
        baseStyle = Theme.of(context).textTheme.headlineLarge;
        fontSize = ResponsiveDesignSystem.getHeadlineLargeSize(context);
        break;
      case TextType.headlineMedium:
        baseStyle = Theme.of(context).textTheme.headlineMedium;
        fontSize = ResponsiveDesignSystem.getHeadlineMediumSize(context);
        break;
      case TextType.bodyLarge:
        baseStyle = Theme.of(context).textTheme.bodyLarge;
        fontSize = ResponsiveDesignSystem.getBodyLargeSize(context);
        break;
      case TextType.bodyMedium:
        baseStyle = Theme.of(context).textTheme.bodyMedium;
        fontSize = ResponsiveDesignSystem.getBodyMediumSize(context);
        break;
      default:
        baseStyle = Theme.of(context).textTheme.bodyMedium;
        fontSize = ResponsiveDesignSystem.getBodyMediumSize(context);
    }

    final responsiveStyle = baseStyle?.copyWith(
      fontSize: fontSize,
    ).merge(style);

    return Text(
      text,
      style: responsiveStyle,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      textScaler: textScaler,
    );
  }
}

enum TextType {
  headlineLarge,
  headlineMedium,
  bodyLarge,
  bodyMedium,
  body,
}

class ResponsiveButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;

  const ResponsiveButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveHeight = height ?? ResponsiveDesignSystem.getButtonHeight(context);
    final fontSize = ResponsiveDesignSystem.getButtonFontSize(context);

    if (isOutlined) {
      return SizedBox(
        width: width,
        height: responsiveHeight,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor,
            side: BorderSide(
              color: textColor ?? Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
            textStyle: TextStyle(fontSize: fontSize),
          ),
          child: _buildButtonContent(context, fontSize),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: responsiveHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          textStyle: TextStyle(fontSize: fontSize),
        ),
        child: _buildButtonContent(context, fontSize),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context, double fontSize) {
    if (isLoading) {
      return SizedBox(
        height: fontSize,
        width: fontSize * 3,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: isOutlined
                ? (textColor ?? Theme.of(context).colorScheme.primary)
                : (textColor ?? Colors.white),
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: fontSize * 1.2),
          SizedBox(width: fontSize / 2),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}

class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.elevation,
    this.onTap,
    this.backgroundColor,
    this.borderRadius,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding = padding ??
        EdgeInsets.all(ResponsiveDesignSystem.getHorizontalPadding(context) / 2);
    final responsiveBorderRadius = borderRadius ??
        BorderRadius.circular(ResponsiveDesignSystem.getCardBorderRadius(context));

    return Card(
      elevation: elevation ?? AppTheme.elevationMedium,
      color: backgroundColor ?? Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: responsiveBorderRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: responsiveBorderRadius,
        child: Container(
          width: width,
          height: height,
          padding: responsivePadding,
          child: child,
        ),
      ),
    );
  }
}

class ResponsiveImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool isHero;

  const ResponsiveImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isHero = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveHeight = height ?? ResponsiveDesignSystem.getImageHeight(context, isHero: isHero);
    final responsiveBorderRadius = borderRadius ??
        BorderRadius.circular(ResponsiveDesignSystem.getCardBorderRadius(context));

    Widget image;
    if (imageUrl.startsWith('http')) {
      image = Image.network(
        imageUrl,
        width: width,
        height: responsiveHeight,
        fit: fit,
      );
    } else {
      image = Image.asset(
        imageUrl,
        width: width,
        height: responsiveHeight,
        fit: fit,
      );
    }

    return ClipRRect(
      borderRadius: responsiveBorderRadius,
      child: image,
    );
  }
}

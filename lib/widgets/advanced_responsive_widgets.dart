import 'package:flutter/material.dart';
import '../utils/responsive_design_system.dart';

class ResponsiveLayoutBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints) builder;

  const ResponsiveLayoutBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(context, constraints);
      },
    );
  }
}

class AdaptiveLayout extends StatelessWidget {
  final Widget Function(BuildContext context) mobileBuilder;
  final Widget Function(BuildContext context)? tabletBuilder;
  final Widget Function(BuildContext context)? desktopBuilder;

  const AdaptiveLayout({
    super.key,
    required this.mobileBuilder,
    this.tabletBuilder,
    this.desktopBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= ResponsiveDesignSystem.tabletBreakpoint &&
            desktopBuilder != null) {
          return desktopBuilder!(context);
        } else if (constraints.maxWidth >= ResponsiveDesignSystem.mobileBreakpoint &&
            tabletBuilder != null) {
          return tabletBuilder!(context);
        } else {
          return mobileBuilder(context);
        }
      },
    );
  }
}

class ResponsiveSafeArea extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;
  final EdgeInsets minimum;

  const ResponsiveSafeArea({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.minimum = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    // On larger screens, we might want to add additional padding
    final extraPadding = ResponsiveDesignSystem.isDesktop(context) ? 16.0 : 0.0;

    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      minimum: EdgeInsets.fromLTRB(
        minimum.left + extraPadding,
        minimum.top,
        minimum.right + extraPadding,
        minimum.bottom,
      ),
      child: child,
    );
  }
}

class ResponsiveOrientationBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) portraitBuilder;
  final Widget Function(BuildContext context) landscapeBuilder;

  const ResponsiveOrientationBuilder({
    super.key,
    required this.portraitBuilder,
    required this.landscapeBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? portraitBuilder(context)
            : landscapeBuilder(context);
      },
    );
  }
}

class ResponsiveScrollView extends StatelessWidget {
  final List<Widget> children;
  final bool reverse;
  final EdgeInsetsGeometry? padding;
  final bool primary;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final Clip clipBehavior;

  const ResponsiveScrollView({
    super.key,
    required this.children,
    this.reverse = false,
    this.padding,
    this.primary = false,
    this.physics,
    this.controller,
    this.clipBehavior = Clip.hardEdge,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: ResponsiveDesignSystem.getHorizontalPadding(context),
          vertical: ResponsiveDesignSystem.getVerticalPadding(context),
        );

    return SingleChildScrollView(
      reverse: reverse,
      padding: responsivePadding,
      primary: primary,
      physics: physics,
      controller: controller,
      clipBehavior: clipBehavior,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double spacing;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    // On mobile, stack vertically
    if (ResponsiveDesignSystem.isMobile(context)) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: _addSpacingColumn(),
      );
    }
    
    // On tablet and desktop, arrange horizontally
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: _addSpacingRow(),
    );
  }

  List<Widget> _addSpacingColumn() {
    final List<Widget> spacedChildren = [];
    
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(height: spacing));
      }
    }
    
    return spacedChildren;
  }

  List<Widget> _addSpacingRow() {
    final List<Widget> spacedChildren = [];
    
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(width: spacing));
      }
    }
    
    return spacedChildren;
  }
}

class ResponsiveWrap extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;
  final WrapAlignment runAlignment;
  final WrapCrossAlignment crossAxisAlignment;

  const ResponsiveWrap({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    // Adjust spacing based on screen size
    final adjustedSpacing = ResponsiveDesignSystem.isMobile(context)
        ? spacing * 0.75
        : spacing;
    
    final adjustedRunSpacing = ResponsiveDesignSystem.isMobile(context)
        ? runSpacing * 0.75
        : runSpacing;

    return Wrap(
      spacing: adjustedSpacing,
      runSpacing: adjustedRunSpacing,
      alignment: alignment,
      runAlignment: runAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}

class ResponsiveConstrainedBox extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final double? maxHeight;
  final double? minWidth;
  final double? minHeight;

  const ResponsiveConstrainedBox({
    super.key,
    required this.child,
    this.maxWidth,
    this.maxHeight,
    this.minWidth,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    // Default max width based on screen size
    final defaultMaxWidth = ResponsiveDesignSystem.getContainerWidth(context);
    
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? defaultMaxWidth,
        maxHeight: maxHeight ?? double.infinity,
        minWidth: minWidth ?? 0.0,
        minHeight: minHeight ?? 0.0,
      ),
      child: child,
    );
  }
}

class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: ResponsiveDesignSystem.getHorizontalPadding(context),
          vertical: ResponsiveDesignSystem.getVerticalPadding(context),
        );

    return Padding(
      padding: responsivePadding,
      child: child,
    );
  }
}

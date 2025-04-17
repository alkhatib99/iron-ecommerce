import 'package:flutter/material.dart';

class ResponsiveDesignSystem {
  // Screen size breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Device type detection
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  // Responsive spacing
  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return 16.0;
    } else if (width < tabletBreakpoint) {
      return 24.0;
    } else {
      return 32.0;
    }
  }

  static double getVerticalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return 16.0;
    } else if (width < tabletBreakpoint) {
      return 24.0;
    } else {
      return 32.0;
    }
  }

  // Responsive grid columns
  static int getGridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return 1;
    } else if (width < tabletBreakpoint) {
      return 2;
    } else if (width < desktopBreakpoint) {
      return 3;
    } else {
      return 4;
    }
  }

  // Responsive font sizes
  static double getHeadlineLargeSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return 24.0;
    } else if (width < tabletBreakpoint) {
      return 28.0;
    } else {
      return 32.0;
    }
  }

  static double getHeadlineMediumSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return 20.0;
    } else if (width < tabletBreakpoint) {
      return 24.0;
    } else {
      return 28.0;
    }
  }

  static double getBodyLargeSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return 16.0;
    } else if (width < tabletBreakpoint) {
      return 18.0;
    } else {
      return 20.0;
    }
  }

  static double getBodyMediumSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return 14.0;
    } else if (width < tabletBreakpoint) {
      return 16.0;
    } else {
      return 18.0;
    }
  }

  // Responsive container widths
  static double getContainerWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return width * 0.9;
    } else if (width < tabletBreakpoint) {
      return width * 0.85;
    } else if (width < desktopBreakpoint) {
      return width * 0.8;
    } else {
      return 1140.0; // Max width for large screens
    }
  }

  // Responsive image sizes
  static double getImageHeight(BuildContext context, {bool isHero = false}) {
    final width = MediaQuery.of(context).size.width;
    if (isHero) {
      if (width < mobileBreakpoint) {
        return 200.0;
      } else if (width < tabletBreakpoint) {
        return 300.0;
      } else {
        return 400.0;
      }
    } else {
      if (width < mobileBreakpoint) {
        return 150.0;
      } else if (width < tabletBreakpoint) {
        return 200.0;
      } else {
        return 250.0;
      }
    }
  }

  // Responsive button sizes
  static double getButtonHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return 48.0;
    } else {
      return 56.0;
    }
  }

  static double getButtonFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return 14.0;
    } else {
      return 16.0;
    }
  }

  // Responsive card sizes
  static double getCardBorderRadius(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return 8.0;
    } else {
      return 12.0;
    }
  }

  // Responsive layout helpers
  static Widget responsiveWrapper({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  // Orientation-specific layouts
  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  static Widget orientationWrapper({
    required BuildContext context,
    required Widget portrait,
    required Widget landscape,
  }) {
    return isPortrait(context) ? portrait : landscape;
  }
}

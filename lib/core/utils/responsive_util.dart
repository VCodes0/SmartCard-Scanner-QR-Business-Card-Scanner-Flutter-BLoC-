import 'package:flutter/material.dart';

/// Responsive utility class for handling different screen sizes
class ResponsiveUtil {
  /// Get responsive padding based on screen width
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return const EdgeInsets.all(48.0);
    } else if (width >= 600) {
      return const EdgeInsets.all(32.0);
    } else {
      return const EdgeInsets.all(16.0);
    }
  }

  /// Get responsive horizontal padding
  static EdgeInsets getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return const EdgeInsets.symmetric(horizontal: 100.0);
    } else if (width >= 600) {
      return const EdgeInsets.symmetric(horizontal: 48.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 24.0);
    }
  }

  /// Get responsive font size
  static double getResponsiveFontSize(
    BuildContext context, {
    required double baseFontSize,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return baseFontSize * 1.3;
    } else if (width >= 600) {
      return baseFontSize * 1.15;
    } else {
      return baseFontSize;
    }
  }

  /// Get responsive icon size
  static double getResponsiveIconSize(
    BuildContext context, {
    required double baseSize,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return baseSize * 1.5;
    } else if (width >= 600) {
      return baseSize * 1.2;
    } else {
      return baseSize;
    }
  }

  /// Check if device is tablet or larger
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  /// Check if device is desktop or larger
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  /// Get max width for content containers
  static double getMaxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return 900; // Desktop max width
    } else if (width >= 600) {
      return 700; // Tablet max width
    } else {
      return width; // Mobile full width
    }
  }

  /// Get responsive spacing
  static double getResponsiveSpacing(
    BuildContext context, {
    required double baseSpacing,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return baseSpacing * 1.5;
    } else if (width >= 600) {
      return baseSpacing * 1.2;
    } else {
      return baseSpacing;
    }
  }

  /// Get number of columns for grid layout
  static int getGridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return 3;
    } else if (width >= 600) {
      return 2;
    } else {
      return 1;
    }
  }

  /// Get responsive border radius
  static double getResponsiveBorderRadius(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 600) {
      return 16.0;
    } else {
      return 12.0;
    }
  }
}

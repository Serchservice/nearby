import 'package:flutter/widgets.dart';

/// A utility class for managing responsive breakpoints and screen properties.
///
/// This class provides a convenient way to determine whether the current screen size
/// is categorized as mobile, tablet, or desktop based on predefined breakpoints.
/// Additionally, it provides access to other screen-related properties such as width,
/// height, padding, and text scaling factor.
class ResponsiveBreakpoint {
  /// The maximum width for a screen to be considered as mobile.
  static const double mobileBreakpoint = 600;

  /// The maximum width for a screen to be considered as tablet.
  static const double tabletBreakpoint = 1024;

  late Size _size;

  /// Private constructor to prevent direct instantiation.
  ResponsiveBreakpoint._();

  /// Initializes the breakpoints with the given [BuildContext].
  ///
  /// This method must be called before accessing any properties of the class.
  /// Returns an instance of `ResponsiveBreakpoint` for convenient usage.
  ///
  /// Example:
  /// ```dart
  /// final responsive = ResponsiveBreakpoint.init(context);
  /// if (responsive.isMobile) {
  ///   print('This is a mobile screen.');
  /// }
  /// ```
  static ResponsiveBreakpoint init(BuildContext context) {
    final instance = ResponsiveBreakpoint._();
    instance._size = MediaQuery.sizeOf(context);

    return instance;
  }

  /// Returns `true` if the screen width is less than the [mobileBreakpoint].
  bool get isMobile => _size.width < mobileBreakpoint;

  /// Returns `true` if the screen width is between the [mobileBreakpoint] and [tabletBreakpoint].
  bool get isTablet => _size.width >= mobileBreakpoint && _size.width < tabletBreakpoint;

  /// Returns `true` if the screen width is greater than or equal to the [tabletBreakpoint].
  bool get isDesktop => _size.width >= tabletBreakpoint;

  /// The current screen width.
  double get screenWidth => _size.width;

  /// The current screen height.
  double get screenHeight => _size.height;
}

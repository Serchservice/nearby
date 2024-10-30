import 'package:get/get.dart';

class Sizing {
  /// Calculate margins and paddings
  static double _space(double base) => base * Get.width / 360.0;

  /// For Margin and Padding calculation (Responsiveness)
  static double space(double size) => _space(size);

  /// Calculate font sizes
  // static double _calculateFont(double baseFontSize) => baseFontSize * (360.0 / Get.width);
  static double _font(double base) => base;

  /// For Font Size calculations (Responsiveness)
  static double font(double size) => _font(size);
}
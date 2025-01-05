import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

/// Provides platform identification utilities.
class PlatformEngine {
  // Private constructor for singleton pattern
  PlatformEngine._();

  // The single instance of the Platform
  static final PlatformEngine _instance = PlatformEngine._();

  /// Access the singleton instance of [PlatformEngine].
  static PlatformEngine get instance => _instance;

  /// Returns `true` if the application is running on a web platform.
  bool get isWeb => kIsWeb;

  /// Returns `true` if the application is running on an Android device.
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Returns `true` if the application is running on an iOS device.
  bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Returns `true` if the application is running on an MacOS device.
  bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// Returns `true` if the application is running on an Linux device.
  bool get isLinux => !kIsWeb && Platform.isLinux;

  /// Returns `true` if the application is running on an Windows device.
  bool get isWindows => !kIsWeb && Platform.isWindows;

  /// Returns `true` if the application is running on an mobile device.
  bool get isMobile => !kIsWeb && (isAndroid || isIOS);

  /// Returns `true` if the application is running on an desktop device.
  bool get isDesktop => !kIsWeb && (isLinux || isMacOS || isWindows);
}
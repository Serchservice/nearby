import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// Abstract class to define the base structure for a notification service that handles
/// displaying different types of notifications.
abstract class NotificationService {

  /// Displays a success notification with the given message and optional callbacks.
  ///
  /// @param title The title of the notification. Defaults to "Success notification".
  /// @param message The message of the notification. This is required.
  /// @param duration The duration for which the notification will be displayed, in seconds. Defaults to 5.
  /// @param onTap Optional callback to be called when the notification is tapped.
  /// @param onClose Optional callback to be called when the notification is closed.
  /// @param onComplete Optional callback to be called when the notification completes its display duration.
  /// @param onDismissed Optional callback to be called when the notification is dismissed.
  ToastificationItem success({
    String title = "Success notification",
    required String message,
    int duration = 5,
    Alignment position = Alignment.topRight,
    void Function(ToastificationItem item)? onTap,
    void Function(ToastificationItem item)? onClose,
    void Function(ToastificationItem item)? onComplete,
    void Function(ToastificationItem item)? onDismissed
  });

  /// Displays an error notification with the given message and optional callbacks.
  ///
  /// @param title The title of the notification. Defaults to "Error notification".
  /// @param message The message of the notification. This is required.
  /// @param duration The duration for which the notification will be displayed, in seconds. Defaults to 5.
  /// @param onTap Optional callback to be called when the notification is tapped.
  /// @param onClose Optional callback to be called when the notification is closed.
  /// @param onComplete Optional callback to be called when the notification completes its display duration.
  /// @param onDismissed Optional callback to be called when the notification is dismissed.
  ToastificationItem error({
    String title = "Error notification",
    required String message,
    int duration = 5,
    Alignment position = Alignment.topRight,
    void Function(ToastificationItem item)? onTap,
    void Function(ToastificationItem item)? onClose,
    void Function(ToastificationItem item)? onComplete,
    void Function(ToastificationItem item)? onDismissed
  });

  /// Displays an informational notification with the given message and optional callbacks.
  ///
  /// @param title The title of the notification. Defaults to "For your information,".
  /// @param message The message of the notification. This is required.
  /// @param duration The duration for which the notification will be displayed, in seconds. Defaults to 5.
  /// @param onTap Optional callback to be called when the notification is tapped.
  /// @param onClose Optional callback to be called when the notification is closed.
  /// @param onComplete Optional callback to be called when the notification completes its display duration.
  /// @param onDismissed Optional callback to be called when the notification is dismissed.
  ToastificationItem info({
    String title = "For your information,",
    required String message,
    int duration = 5,
    Alignment position = Alignment.topRight,
    void Function(ToastificationItem item)? onTap,
    void Function(ToastificationItem item)? onClose,
    void Function(ToastificationItem item)? onComplete,
    void Function(ToastificationItem item)? onDismissed
  });

  /// Displays an warning notification with the given message and optional callbacks.
  ///
  /// @param title The title of the notification. Defaults to "Important!".
  /// @param message The message of the notification. This is required.
  /// @param duration The duration for which the notification will be displayed, in seconds. Defaults to 5.
  /// @param onTap Optional callback to be called when the notification is tapped.
  /// @param onClose Optional callback to be called when the notification is closed.
  /// @param onComplete Optional callback to be called when the notification completes its display duration.
  /// @param onDismissed Optional callback to be called when the notification is dismissed.
  ToastificationItem warn({
    String title = "Important!",
    required String message,
    int duration = 5,
    Alignment position = Alignment.topRight,
    void Function(ToastificationItem item)? onTap,
    void Function(ToastificationItem item)? onClose,
    void Function(ToastificationItem item)? onComplete,
    void Function(ToastificationItem item)? onDismissed
  });

  /// Displays a small tip notification with the given message and optional callbacks.
  ///
  /// @param color The color of the notification. Defaults to current [Theme].
  /// @param message The message of the notification. This is required.
  /// @param duration The duration for which the notification will be displayed, in seconds. Defaults to 5.
  void tip({Color? color, required String message, int duration = 5});

  /// Displays a custom notification with the given content and duration.
  ///
  /// @param content The custom content of the notification.
  /// @param duration The duration for which the notification will be displayed, in seconds. Defaults to 5.
  ToastificationItem custom({int duration = 5, required Widget content});

  /// Find a toast notification by item id
  ToastificationItem? findById(String id);

  /// Dismiss either all, by [ToastificationItem] notification or by [ToastificationItem] notification id
  void dismiss({String? id, ToastificationItem? notification});
}
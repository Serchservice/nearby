import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import 'package:drive/library.dart';

class Notification implements NotificationService {
  ToastificationItem show({
    required String title,
    required String description,
    int duration = 5,
    Alignment position = Alignment.topRight,
    ToastificationType type = ToastificationType.success,
    Color color = Colors.green,
    IconData? icon,
    void Function(ToastificationItem item)? onTap,
    void Function(ToastificationItem item)? onClose,
    void Function(ToastificationItem item)? onDismissed,
    void Function(ToastificationItem item)? onComplete,
  }) {
    return toastification.show(
      type: type,
      style: ToastificationStyle.minimal,
      autoCloseDuration: Duration(seconds: duration),
      title: title != ""
          ? Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SText(
                  text: title,
                  size: 16,
                  weight: FontWeight.bold,
                  color: Get.theme.primaryColor
              ),
          )
          : null,
      description: description != ""
          ? Padding(
              padding: const EdgeInsets.only(top: 6),
              child: SText(
                  text: description,
                  color: Get.theme.primaryColor
              ),
            )
          : null,
      alignment: position,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      icon: icon != null ? Icon(
          icon,
          color: color,
          size: 32
      ) : null,
      primaryColor: color,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(4),
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      borderSide: BorderSide.none,
      pauseOnHover: true,
      dragToClose: true,
      progressBarTheme: ProgressIndicatorThemeData(
        linearTrackColor: Colors.transparent,
        linearMinHeight: 2,
        color: color
      ),
      // applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: onTap,
        onCloseButtonTap: onClose,
        onAutoCompleteCompleted: onComplete,
        onDismissed: onDismissed,
      ),
    );
  }

  @override
  ToastificationItem custom({
    int duration = 5,
    required Widget content,
  }) {
    return toastification.show(
      autoCloseDuration: Duration(seconds: duration),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      primaryColor: Colors.grey,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  @override
  ToastificationItem error({
    String title = "Error notification",
    required String message,
    int duration = 5,
    Alignment position = Alignment.topRight,
    void Function(ToastificationItem item)? onTap,
    void Function(ToastificationItem item)? onClose,
    void Function(ToastificationItem item)? onComplete,
    void Function(ToastificationItem item)? onDismissed,
  }) {
    return show(
      title: title,
      description: message,
      duration: duration,
      type: ToastificationType.error,
      color: Colors.red,
      icon: Icons.error,
      onTap: onTap,
      onClose: onClose,
      onComplete: onComplete,
      onDismissed: onDismissed,
      position: position,
    );
  }

  @override
  ToastificationItem info({
    String title = "For your information",
    required String message,
    int duration = 5,
    Alignment position = Alignment.topRight,
    void Function(ToastificationItem item)? onTap,
    void Function(ToastificationItem item)? onClose,
    void Function(ToastificationItem item)? onComplete,
    void Function(ToastificationItem item)? onDismissed,
  }) {
    return show(
      title: title,
      description: message,
      duration: duration,
      type: ToastificationType.info,
      color: Colors.blue,
      icon: Icons.info,
      onTap: onTap,
      onClose: onClose,
      onComplete: onComplete,
      onDismissed: onDismissed,
      position: position,
    );
  }

  @override
  void tip({required String message, int duration = 5, Color? color}) async {
    await Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: color ?? Get.theme.appBarTheme.backgroundColor,
        textColor: color != null ? CommonColors.lightTheme : Get.theme.primaryColor,
        gravity: ToastGravity.BOTTOM
    );
  }

  @override
  ToastificationItem success({
    String title = "Success notification",
    required String message,
    int duration = 5,
    Alignment position = Alignment.topRight,
    void Function(ToastificationItem item)? onTap,
    void Function(ToastificationItem item)? onClose,
    void Function(ToastificationItem item)? onComplete,
    void Function(ToastificationItem item)? onDismissed,
  }) {
    return show(
      title: title,
      description: message,
      duration: duration,
      type: ToastificationType.success,
      color: Colors.green,
      icon: Icons.check_circle,
      onTap: onTap,
      onClose: onClose,
      onComplete: onComplete,
      onDismissed: onDismissed,
      position: position,
    );
  }

  @override
  ToastificationItem warn({
    String title = "Important!",
    required String message,
    int duration = 5,
    Alignment position = Alignment.topRight,
    void Function(ToastificationItem item)? onTap,
    void Function(ToastificationItem item)? onClose,
    void Function(ToastificationItem item)? onComplete,
    void Function(ToastificationItem item)? onDismissed,
  }) {
    return show(
      title: title,
      description: message,
      duration: duration,
      type: ToastificationType.warning,
      color: Colors.yellow,
      icon: Icons.warning_amber_outlined,
      onTap: onTap,
      onClose: onClose,
      onComplete: onComplete,
      onDismissed: onDismissed,
      position: position,
    );
  }

  @override
  ToastificationItem? findById(String id) {
    return toastification.findToastificationItem(id);
  }

  @override
  void dismiss({String? id, ToastificationItem? notification}) {
    if(id != null) {
      toastification.dismissById(id);
    } else if(notification != null) {
      toastification.dismiss(notification);
    } else {
      toastification.dismissAll();
    }
  }
}

final NotificationService notify = Notification();
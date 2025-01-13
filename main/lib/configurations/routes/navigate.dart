import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Navigate<T> {
  static final navigatorKey = GlobalKey<NavigatorState>();

  /// To close open dialogs, bottom sheet, snackbars `[PAGE]` => `Get.back`
  static void close<T extends Object>({
    bool closeAll = true,
    bool closeSnackbar = true,
    bool closeDialog = true,
    bool closeBottomSheet = true,
    String? id,
    T? result,
  }) => Get.close(closeAll: closeAll, closeSnackbar: closeSnackbar, closeDialog: closeDialog, closeBottomSheet: closeBottomSheet, id: id, result: result);

  /// To go back to previous `[PAGE]` => `Get.back`
  static void back<T>({T? result, bool canPop = true, String? id}) => Get.back(result: result, canPop: canPop, id: id);

  /// Navigate to new page `[PAGE]` => `Get.toNamed`
  static Future<T?>? to<T>(String page, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) async => await Get.toNamed(page, arguments: arguments, parameters: parameters);

  /// Navigate to new page `[PAGE]` => `Get.toNamed`
  static Future<T?>? toPage<T>({
    required Widget widget,
    required String route,
    dynamic arguments,
  }) async => await Get.to(() => widget, routeName: route, arguments: arguments, curve: Curves.bounceIn);

  /// Leave the current page to another page `[PAGE]` => `Get.off`
  static Future<T?>? off<T>(dynamic page, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) async => await Get.offNamed(page, arguments: arguments, parameters: parameters);

  /// Leave all pages till the `[PREDICATE]` is true and push `[PAGE]` to the stack => `Get.offNamedUntil`
  ///
  /// [predicate] can be used like this: `Get.offNamedUntil(page, ModalRoute.withName('/home'))` to pop routes in
  /// stack until home, or like this: `Get.offNamedUntil((route) => !Get.isDialogOpen())`, to make sure the dialog is closed
  static Future<T?>? offTill<T>(String page, GetPage predicate, {
    String? id,
    dynamic arguments,
    Map<String, String>? parameters,
  }) async => await Get.offNamedUntil(page, (route) => route == predicate, id: id, arguments: arguments, parameters: parameters);

  /// Leave all pages till the `[PREDICATE]` is true, which is optional, and push `[PAGE]` to the stack => `Get.offAllNamed`
  ///
  /// [predicate] can be used like this: `Get.offNamedUntil(page, ModalRoute.withName('/home'))` to pop routes in
  /// stack until home, or like this: `Get.offNamedUntil((route) => !Get.isDialogOpen())`, to make sure the dialog is closed
  static Future<T?>? all<T>(String route, {
    dynamic arguments,
    String? id,
    Map<String, String>? parameters,
  }) async => await Get.offAllNamed(route, parameters: parameters, arguments: arguments, id: id);

  /// Pop the current named `[PAGE]` and pushes a new `[PAGE]` to the stack in its place => `Get.offAndToNamed`
  static Future<T?>? offTo<T>(String page, {
    dynamic arguments,
    String? id,
    dynamic result,
    Map<String, String>? parameters,
  }) async => await Get.offAndToNamed(page, arguments: arguments, id: id, result: result, parameters: parameters);

  /// Calls pop several times in the stack until `[predicate]` returns true => `Get.until`
  ///
  /// `[id]` is for when you are using nested navigation, as explained in documentation.
  ///
  /// `[predicate]` can be used like this: `Get.until((route) => Get.currentRoute == '/home')`so when you get to home page,
  /// or also like this: `Get.until((route) => !Get.isDialogOpen())`, to make sure the dialog is closed
  static void till<T>(GetPage predicate, {String? id}) => Get.until((route) => route == predicate, id: id);

  static void bottomSheet({
    required Widget sheet,
    required String route,
    Object? arguments,
    Color background = Colors.transparent,
    bool isScrollable = false,
    bool safeArea = false
  }) {
    Get.bottomSheet(
      sheet,
      backgroundColor: background,
      isScrollControlled: isScrollable,
      ignoreSafeArea: safeArea,
      settings: RouteSettings(name: route, arguments: arguments)
    );
  }
}
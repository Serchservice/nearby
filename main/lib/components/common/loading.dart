
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loading extends StatelessWidget {
  final Widget widget;
  final Color? color;
  final double size;
  final double? value;
  final StrokeCap? stroke;

  Loading({
    super.key,
    this.color,
    this.size = 20,
    this.stroke,
    this.value
  }) : widget = CircularProgressIndicator(
    color: color ?? Get.theme.primaryColor,
    backgroundColor: Colors.transparent,
    strokeWidth: 4.0,
    value: value,
    strokeCap: stroke,
  );

  @override
  Widget build(BuildContext context) => SizedBox(
    height: size,
    width: size,
    child: widget
  );

  static void open({
    Color? color, double size = 20,
    double? value, StrokeCap? stroke,
    String? route
  }) => Get.dialog(
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Loading(
            color: color,
            size: size,
            value: value,
            stroke: stroke,
          ),
        ),
      ],
    ),
    routeSettings: RouteSettings(name: route ?? "/loading"),
    barrierDismissible: false
  );
}
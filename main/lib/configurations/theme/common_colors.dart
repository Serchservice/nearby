import 'package:flutter/material.dart';

///Set of constant colors used for the UI layout of the app.
///
///It comprises of both colors used in the light and dark theme of the UI
abstract class CommonColors{
  static const Color color = Color(0xff4361EE);

  static const Color lightTheme = Color(0xffFFFFFF);
  static const Color lightTheme2 = Color(0xffF1F1F1);

  static const Color darkTheme = Color(0xff050404);
  static const Color darkTheme2 = Color(0xff222222);

  static const Color hint = Color(0xff8C8C8C);
  static const Color grey = Color(0xff383838);
  static const Color hinted = Color(0xffD9D9D9);

  static const Color allday = Color(0xff000870);
  static const Color payu = Color(0xffB80000);
  static const Color premium = Color(0xffB8006B);
  static const Color freePlan = Color(0xff2C0F0C);

  static const Color green = Color(0xff06C270);
  static const Color yellow = Color(0xffFF9E53);

  static const Color error = Color(0xffFF3B3B);
  static const Color info = Color(0xffAAAAAA);
  static const Color warning = Color(0xffffcc00);
  static const Color success = Color(0xff06c270);

  static const Color shimmerBase = Color.fromARGB(255, 176, 176, 176);
  static const Color shimmerHigh = Color.fromARGB(255, 210, 210, 210);
  static const Color shimmer = Color(0xFF111111);
}
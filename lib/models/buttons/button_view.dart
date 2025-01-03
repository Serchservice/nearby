import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class ButtonView {
  final IconData icon;
  final int index;
  final String header;
  final String body;
  final double number;
  final Color color;
  final List<Color> colors;
  final String path;
  final String image;
  final VoidCallback? onClick;
  final Widget? child;

  ButtonView({
    this.icon = Icons.copy,
    this.index = 0,
    this.header = "",
    this.body = "",
    this.number = 0.0,
    this.color = CommonColors.lightTheme,
    this.path = "/",
    this.onClick,
    this.child,
    this.image = "",
    this.colors = const []
  });
}
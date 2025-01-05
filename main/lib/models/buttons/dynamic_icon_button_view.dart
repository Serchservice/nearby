import 'package:flutter/material.dart';

/// This class will be used for views like: BottomNavigation
class DynamicIconButtonView {
  final IconData icon;
  final IconData active;
  final int index;
  final String title;
  final String path;

  DynamicIconButtonView({
    this.icon = Icons.copy,
    this.index = 0,
    this.active = Icons.copy,
    this.title = "",
    this.path = "/"
  });
}
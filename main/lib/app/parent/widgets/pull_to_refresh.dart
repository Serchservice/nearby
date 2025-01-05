import 'package:flutter/material.dart';

class PullToRefresh extends StatelessWidget {
  final VoidCallback onRefreshed;
  final Color? color;
  final Color? backgroundColor;
  final Widget? child;

  const PullToRefresh({super.key, required this.onRefreshed, this.color, this.backgroundColor, this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: color ?? Theme.of(context).primaryColor,
      onRefresh: () => Future.sync(() => onRefreshed.call()),
      backgroundColor: backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
      child: child ?? Container(),
    );
  }
}
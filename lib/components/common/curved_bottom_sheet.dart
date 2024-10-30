import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class CurvedBottomSheet extends StatelessWidget {
  const CurvedBottomSheet({
    super.key,
    this.backgroundColor,
    required this.child,
    this.padding,
    this.borderRadius,
    this.safeArea = false,
    this.margin
  });

  final Color? backgroundColor;
  final Widget child;
  final bool safeArea;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: safeArea,
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: margin != null
            ? borderRadius ?? BorderRadius.circular(12)
            : borderRadius ?? const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          child: Container(
            color: backgroundColor ?? Theme.of(context).bottomAppBarTheme.color,
            padding: padding ?? EdgeInsets.symmetric(vertical: Sizing.space(15), horizontal: Sizing.space(10)),
            child: child
          )
        ),
      ),
    );
  }
}
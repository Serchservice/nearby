import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class NavigatorButton extends StatelessWidget {
  final String header;
  final double headerSize;
  final String? detail;
  final double detailSize;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final Color? iconColor;
  final VoidCallback? onPressed;
  final Widget? suffixWidget;
  final Color? textColor;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Widget? child;
  final double radius;

  const NavigatorButton({
    super.key,
    this.header = "",
    this.headerSize = 16,
    this.detail,
    this.detailSize = 14,
    this.prefixIcon,
    this.onPressed,
    this.suffixWidget,
    this.iconColor,
    this.textColor,
    this.iconSize,
    this.padding,
    this.prefixWidget,
    this.backgroundColor,
    this.child,
    this.radius = 5
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: padding ?? EdgeInsets.all(Sizing.space(10)),
            child: buildChild(context),
          ),
        ),
      ),
    );
  }

  Widget buildChild(BuildContext context) {
    if(child != null) {
      return child!;
    } else {
      return Row(
        children: [
          showPrefixIcon(context),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SText(
                  text: header,
                  size: headerSize,
                  color: textColor ?? Theme.of(context).primaryColor
                ),
                showDetails(context)
              ],
            )
          ),
          showWidget(suffixWidget)
        ],
      );
    }
  }

  Widget showPrefixIcon(context) {
    if(prefixWidget != null) {
      return prefixWidget!;
    } else if(prefixIcon == null) {
      return Container();
    } else {
      return Icon(
        prefixIcon,
        color: iconColor ?? Theme.of(context).primaryColorLight,
        size: iconSize ?? Sizing.font(25)
      );
    }
  }

  Widget showDetails(BuildContext context) {
    if(detail != null && detail!.isNotEmpty) {
      return SText(
        text: detail!,
        color: CommonColors.hint,
        size: detailSize
      );
    } else {
      return Container();
    }
  }

  Widget showWidget(Widget? suffixWidget) {
    if(suffixWidget == null) {
      return Container();
    } else {
      return suffixWidget;
    }
  }
}
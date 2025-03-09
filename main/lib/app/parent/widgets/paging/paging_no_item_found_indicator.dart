import 'package:flutter/material.dart';
import 'package:smart/smart.dart';
import 'package:drive/library.dart' show CommonColors;

class PagingNoItemFoundIndicator extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Widget? customIcon;
  final Color? textColor;
  final VoidCallback? onRefresh;
  final Color? buttonColor;

  const PagingNoItemFoundIndicator({
    super.key,
    required this.message,
    this.icon,
    this.customIcon,
    this.textColor,
    this.onRefresh,
    this.buttonColor
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(opacity: 0.2, child: _buildIcon(context)),
          TextBuilder.center(
            text: message,
            autoSize: false,
            color: textColor ?? Theme.of(context).primaryColor,
          ),
          if(onRefresh.isNotNull) ...[
            TextButton(
              onPressed: onRefresh,
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.resolveWith((states) {
                  return buttonColor ?? CommonColors.instance.bluish.lighten(48);
                }),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 6))
              ),
              child: TextBuilder(
                text: "Refresh",
                weight: FontWeight.bold,
                color: buttonColor ?? CommonColors.instance.bluish
              )
            )
          ]
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    if(icon.isNotNull) {
      return Icon(
        icon,
        color: textColor ?? Theme.of(context).primaryColor,
        size: 100
      );
    } else if(customIcon.isNotNull) {
      return customIcon!;
    } else {
      return Container();
    }
  }
}

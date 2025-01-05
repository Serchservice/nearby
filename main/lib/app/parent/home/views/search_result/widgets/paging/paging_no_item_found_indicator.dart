import 'package:drive/library.dart';
import 'package:flutter/material.dart';

class PagingNoItemFoundIndicator extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Widget? customIcon;
  final Color? textColor;

  const PagingNoItemFoundIndicator({
    super.key,
    required this.message,
    this.icon,
    this.customIcon,
    this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.2,
            child: _buildIcon(context),
          ),
          const SizedBox(height: 10),
          SText.center(
            text: message,
            autoSize: false,
            color: textColor ?? Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    if(icon != null) {
      return Icon(
        icon,
        color: textColor ?? Theme.of(context).primaryColor,
        size: 100
      );
    } else if(customIcon != null) {
      return customIcon!;
    } else {
      return Container();
    }
  }
}

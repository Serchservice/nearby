import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drive/library.dart';

class LoadingButton extends StatelessWidget {
  final Color? buttonColor;
  final Color? textColor;
  final double textSize;
  final bool loading;
  final Widget loader;
  final FontWeight textWeight;
  final double borderRadius;
  final String? fontFamily;
  final VoidCallback? onClick;
  final String text;
  final EdgeInsetsGeometry? padding;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double? prefixIconSize;
  final double? suffixIconSize;
  final double? loadingSize;
  final bool notEnabled;
  final bool isCircular;
  final double? width;

  LoadingButton({
    super.key,
    this.buttonColor,
    this.textColor,
    this.textSize = 14,
    this.loading = false,
    this.textWeight = FontWeight.normal,
    this.borderRadius = 8,
    this.onClick,
    required this.text,
    this.padding,
    this.fontFamily,
    this.loadingSize,
    this.prefixIcon,
    this.prefixIconSize = 20,
    this.suffixIcon,
    this.suffixIconSize,
    this.notEnabled = false,
    this.isCircular = true,
    this.width
  }) : loader = Loading(
    color: textColor ?? Get.theme.splashColor,
    size: loadingSize ?? Loading().size
  );

  @override
  Widget build(BuildContext context) {
    final color = notEnabled
      ? buttonColor ?? Theme.of(context).primaryColor
      : textColor ?? Theme.of(context).splashColor;
    final paddingValue = padding ?? EdgeInsets.all(Sizing.space(14));

    // Calculate the width of the label
    double labelWidth = 0;
    if (text.isNotEmpty) {
      final textSpan = TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: textSize,
          fontWeight: textWeight,
        )
      );
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout(maxWidth: double.infinity);
      labelWidth = textPainter.width;
    }

    // Calculate the total width of the button's content
    double contentWidth = labelWidth + paddingValue.horizontal;

    return ClipRRect(
      borderRadius: isCircular
        ? BorderRadius.circular(borderRadius)
        : BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius)
        ),
      child: Material(
        color: notEnabled
          ? textColor ?? Theme.of(context).splashColor
          : buttonColor ?? Theme.of(context).primaryColor,
        child: InkWell(
          onTap: loading || notEnabled ? null : onClick,
          child: Padding(
            padding: paddingValue,
            child: SizedBox(
              width: width ?? contentWidth,
              child: Row(
                mainAxisAlignment: prefixIcon != null && suffixIcon != null
                  ? MainAxisAlignment.spaceBetween
                  : prefixIcon != null || suffixIcon != null
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(prefixIcon != null) ... [
                    Icon(
                      prefixIcon,
                      size: prefixIconSize,
                      color: color
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Center(
                      child: loading ? loader : SText.center(
                        text: text,
                        color: color,
                        size: textSize,
                        weight: textWeight,
                        fontFamily: fontFamily
                      )
                    ),
                  ),
                  if(suffixIcon != null) ...[
                    const SizedBox(width: 10),
                    Icon(
                      prefixIcon,
                      size: suffixIconSize,
                      color: color
                    ),
                  ]
                ],
              )
            )
          ),
        ),
      ),
    );
  }
}
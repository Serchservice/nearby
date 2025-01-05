import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:drive/library.dart';

class SText extends StatelessWidget {
  final double size;
  final String text;
  final FontWeight weight;
  final TextAlign align;
  final FontStyle style;
  final TextOverflow? flow;
  final Color color;
  final bool? wrap;
  final int? lines;
  final String? fontFamily;
  final TextDecoration? decoration;
  final bool autoSize;

  const SText({
    super.key,
    required this.text,
    this.size = 14,
    this.weight = FontWeight.normal,
    this.fontFamily,
    this.align = TextAlign.left,
    this.color = CommonColors.lightTheme,
    this.flow,
    this.style = FontStyle.normal,
    this.decoration,
    this.wrap,
    this.lines,
    this.autoSize = true
  });

  const SText.justify({
    super.key,
    required this.text,
    this.size = 14,
    this.weight = FontWeight.normal,
    this.color = CommonColors.lightTheme,
    this.flow,
    this.style = FontStyle.normal,
    this.decoration,
    this.wrap,
    this.lines,
    this.fontFamily,
    this.autoSize = true
  }) : align = TextAlign.justify;

  const SText.right({
    super.key,
    required this.text,
    this.size = 14,
    this.weight = FontWeight.normal,
    this.color = CommonColors.lightTheme,
    this.flow,
    this.style = FontStyle.normal,
    this.decoration,
    this.wrap,
    this.lines,
    this.fontFamily,
    this.autoSize = true
  }) : align = TextAlign.right;

  const SText.center({
    super.key,
    required this.text,
    this.size = 14,
    this.weight = FontWeight.normal,
    this.color = CommonColors.lightTheme,
    this.flow,
    this.style = FontStyle.normal,
    this.decoration,
    this.wrap,
    this.lines,
    this.fontFamily,
    this.autoSize = true
  }) : align = TextAlign.center;

  @override
  Widget build(BuildContext context) {
    if(autoSize) {
      return AutoSizeText(
        text,
        textAlign: align,
        overflow: flow,
        softWrap: wrap,
        maxLines: lines,
        style: TextStyle(
          fontFamily: fontFamily,
          color: color,
          fontSize: size,
          fontWeight: weight,
          fontStyle: style,
          decoration: decoration,
        ),
      );
    } else {
      return Text(
        text,
        textAlign: align,
        overflow: flow,
        softWrap: wrap,
        maxLines: lines,
        style: TextStyle(
          fontFamily: fontFamily,
          color: color,
          fontSize: size,
          fontWeight: weight,
          fontStyle: style,
          decoration: decoration,
        ),
      );
    }
  }
}
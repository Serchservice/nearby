import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class LineHeader extends StatelessWidget {
  const LineHeader({
    super.key,
    required this.header,
    required this.footer,
    this.headerSize,
    this.footerSize,
    this.color
  });

  final String header;
  final String footer;
  final double? headerSize;
  final double? footerSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SText(
          text: header,
          size: headerSize ?? Sizing.font(20),
          weight: FontWeight.w700,
          color: color ?? Theme.of(context).primaryColor
        ),
        SText(
          text: footer,
          size: footerSize ?? Sizing.font(14),
          color: color ?? Theme.of(context).primaryColor
        ),
        Container(
          width: MediaQuery.sizeOf(context).width,
          height: 3,
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(3),
              bottomRight: Radius.circular(3)
            )
          ),
        )
      ],
    );
  }
}
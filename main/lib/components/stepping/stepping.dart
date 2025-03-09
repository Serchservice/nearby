import 'package:flutter/material.dart';
import 'package:smart/ui.dart';

class Stepping extends StatelessWidget {
  final Color? lineColor;
  final Widget? step;
  final IconData? icon;
  final Widget content;
  final bool showLine;
  final bool showStepCircle;
  final double iconSize;
  final EdgeInsetsGeometry? padding;

  const Stepping({
    super.key,
    this.lineColor,
    this.step,
    required this.content,
    this.showLine = true,
    this.showStepCircle = true,
    this.icon,
    this.iconSize = 20,
    this.padding
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: padding ?? const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                if(showStepCircle) ...[
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      shape: BoxShape.circle
                    ),
                    child: step ?? Icon(
                      icon ?? Icons.arrow_forward_rounded,
                      size: iconSize,
                      color: lineColor ?? Theme.of(context).scaffoldBackgroundColor,
                    ),
                  )
                ],
                if(showLine) ...[
                  Spacing.vertical(4),
                  Expanded(
                    child: VerticalDivider(
                      color: lineColor ?? Theme.of(context).primaryColor,
                      thickness: 2,
                      width: 2
                    ),
                  )
                ]
              ],
            ),
          ),
          Spacing.horizontal(10),
          Expanded(child: content)
        ],
      )
    );
  }
}
import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

import 'interest_viewer_sheet.dart';

class InterestViewer extends StatelessWidget {
  final GoInterest interest;
  final bool isClickable;
  final VoidCallback? onClick;
  final Color? color;
  final Color? buttonColor;
  final String? buttonText;
  final bool isSelected;

  const InterestViewer({
    super.key,
    required this.interest,
    this.onClick,
    this.color,
    this.isSelected = false,
    this.buttonColor,
    this.buttonText
  }) : isClickable = true;

  const InterestViewer.view({
    super.key,
    required this.interest,
    this.color,
    this.isSelected = false,
  }) : isClickable = false, onClick = null, buttonColor = null, buttonText = "";

  @override
  Widget build(BuildContext context) {
    final Color baseColor = color ?? CommonColors.instance.bluish;
    final Color bgColor = isSelected ? baseColor.lighten(45) : baseColor.lighten(10);
    final Color txtColor = isSelected ? baseColor : baseColor.lighten(90);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: bgColor,
        child: InkWell(
          onTap: () => InterestViewerSheet.open(
            interest: interest,
            isClickable: isClickable,
            onClick: onClick,
            buttonColor: buttonColor,
            buttonText: buttonText ?? "Add interest"
          ),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextBuilder(
              text: interest.title,
              size: Sizing.font(14),
              color: txtColor,
              weight: FontWeight.bold,
              flow: TextOverflow.ellipsis
            )
          )
        )
      )
    );
  }
}
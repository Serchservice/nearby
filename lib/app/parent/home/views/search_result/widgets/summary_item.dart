import 'package:drive/library.dart';
import 'package:flutter/material.dart';

class SummaryItem extends StatelessWidget {
  final String title;
  final String value;
  
  const SummaryItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SText(
          text: title,
          color: Theme.of(context).primaryColor,
          size: Sizing.font(14),
        ),
        const SizedBox(width: 10),
        const Expanded(child: Divider()),
        const SizedBox(width: 10),
        SText(
          text: value,
          color: Theme.of(context).primaryColor,
          size: Sizing.font(14),
          weight: FontWeight.bold
        )
      ]
    );
  }
}
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

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
        TextBuilder(
          text: title,
          color: Theme.of(context).primaryColor,
          size: Sizing.font(14),
        ),
        Spacing.horizontal(10),
        const Expanded(child: Divider()),
        Spacing.horizontal(10),
        TextBuilder(
          text: value,
          color: Theme.of(context).primaryColor,
          size: Sizing.font(14),
          weight: FontWeight.bold
        )
      ]
    );
  }
}
import 'package:smart/smart.dart';
import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class GoAddonPlanItem extends StatelessWidget {
  final bool isSelected;
  final GoAddonPlan plan;
  final Color? bgColor;

  const GoAddonPlanItem({
    super.key,
    this.isSelected = false,
    required this.plan,
    this.bgColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: bgColor ?? (isSelected ? CommonColors.instance.bluish : CommonColors.instance.bluish.lighten(23)),
      padding: EdgeInsets.all(8),
      child: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: CommonColors.instance.color.lighten(33),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.access_time,
                  color: CommonColors.instance.color,
                  size: 24,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextBuilder(text: plan.name, color: CommonColors.instance.lightTheme),
                    TextBuilder(
                      text: "${plan.interval} | ${plan.currency}",
                      size: 11,
                      autoSize: false,
                      color: CommonColors.instance.lightTheme,
                    ),
                  ]
                ),
              ),
              TextBuilder(
                text: plan.amount,
                size: 14,
                weight: FontWeight.bold,
                autoSize: false,
                color: CommonColors.instance.lightTheme
              )
            ],
          ),
          TextBuilder(
            text: plan.description,
            size: 12,
            color: CommonColors.instance.lightTheme,
          ),
        ]
      )
    );
  }
}
import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class GoAddonItem extends StatelessWidget {
  final GoAddon addon;
  final Widget? child;

  const GoAddonItem({super.key, required this.addon, this.child});

  @override
  Widget build(BuildContext context) {
    List<String> plans = addon.plans.map((GoAddonPlan plan) => "${plan.interval} (${plan.amount})").toList();

    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: CommonColors.instance.darkTheme2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CommonColors.instance.color.lighten(33),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.extension_outlined,
                  color: CommonColors.instance.color,
                  size: 30,
                ),
              ),
              Expanded(
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextBuilder(
                      text: addon.name,
                      size: 16,
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: CommonColors.instance.bluish),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: TextBuilder(
                        text: addon.type.replaceAll("_", " "),
                        size: 9,
                        autoSize: false,
                        color: CommonColors.instance.bluish
                      )
                    )
                  ]
                ),
              ),
            ],
          ),
          TextBuilder(
            text: addon.description,
            size: 12,
            color: Theme.of(context).primaryColorLight,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: plans.map((String plan) {
                return Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: CommonColors.instance.twitterBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextBuilder(
                    text: plan,
                    size: 12,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            )
          ),
          if (child != null) child!
        ],
      )
    );
  }
}
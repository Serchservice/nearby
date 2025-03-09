import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class GoActivityCardLoading extends StatelessWidget {
  final double? height;
  final double? width;
  const GoActivityCardLoading({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    double contentWidth = width ?? MediaQuery.sizeOf(context).width;

    return LoadingShimmer(
      isDarkMode: Database.instance.isDarkTheme,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: contentWidth,
            height: height ?? 250,
            color: CommonColors.instance.shimmerHigh,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacing.vertical(2),
                Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: CommonColors.instance.shimmerHigh,
                      ),
                    ),
                    Spacing.flexible(),
                    Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: StackedAvatars(
                        avatars: ["", "", "", ""],
                        totalAvatarsInView: 10,
                        isLoading: true,
                        avatarSize: Sizing.font(25),
                      )
                    )
                  ]
                ),
                Container(
                  width: contentWidth / 1.2,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: CommonColors.instance.shimmerHigh,
                  ),
                ),
                Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Avatar(radius: 10, avatar: ""),
                    Container(
                      width: contentWidth / 1.8,
                      height: 14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: CommonColors.instance.shimmerHigh,
                      ),
                    ),
                  ],
                )
              ]
            ),
          )
        ]
      )
    );
  }
}
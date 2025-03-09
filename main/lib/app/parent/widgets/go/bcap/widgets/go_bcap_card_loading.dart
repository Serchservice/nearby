import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class GoBCapCardLoading extends StatelessWidget {
  final double? height;
  final double? width;

  const GoBCapCardLoading({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    double displayHeight = height ?? MediaQuery.sizeOf(context).height;
    double displayWidth = width ?? MediaQuery.sizeOf(context).width;
    double position = 5;
    double spacer = 10;

    if(height.isNotNull) {
      return LoadingShimmer(
        isDarkMode: Database.instance.isDarkTheme,
        content: Container(
          width: displayWidth,
          height: displayHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: CommonColors.instance.shimmerHigh
          )
        )
      );
    }

    return LoadingShimmer(
      isDarkMode: Database.instance.isDarkTheme,
      content: SizedBox(
        height: displayHeight,
        width: displayWidth,
        child: Stack(
          children: [
            Container(
              width: displayWidth,
              height: displayHeight,
              color: CommonColors.instance.shimmerHigh
            ),
            Positioned(
              left: position,
              right: position,
              bottom: position,
              child: Row(
                spacing: spacer,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      spacing: spacer,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: CommonColors.instance.shimmerHigh,
                          ),
                        ),
                        Row(
                          spacing: spacer,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                width: 150,
                                height: 18,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: CommonColors.instance.shimmerHigh,
                                ),
                              ),
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: CommonColors.instance.shimmerHigh,
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: 180,
                          height: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: CommonColors.instance.shimmerHigh,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    spacing: spacer,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: 4.listGenerator.map((_) {
                      return Column(
                        spacing: 4,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: CommonColors.instance.shimmerHigh,
                            ),
                          ),
                          Container(
                            width: 20,
                            height: 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: CommonColors.instance.shimmerHigh,
                            ),
                          ),
                        ]
                      );
                    }).toList()
                  )
                ],
              )
            )
          ]
        )
      ),
    );
  }
}
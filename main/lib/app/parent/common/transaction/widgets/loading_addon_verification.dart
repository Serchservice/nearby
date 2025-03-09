import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class LoadingAddonVerification extends StatelessWidget {
  const LoadingAddonVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingShimmer(
      isDarkMode: Database.instance.isDarkTheme,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(6),
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
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: CommonColors.instance.shimmerHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          height: 14,
                          width: 180,
                          decoration: BoxDecoration(
                            color: CommonColors.instance.shimmerHigh,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(12),
                          height: 15,
                          width: 100,
                          decoration: BoxDecoration(
                            color: CommonColors.instance.shimmerHigh,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ]
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(12),
                height: 24,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: CommonColors.instance.shimmerHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: 4.listGenerator.map((int plan) {
                    return Container(
                      padding: EdgeInsets.all(12),
                      height: 20,
                      width: 80,
                      decoration: BoxDecoration(
                        color: CommonColors.instance.shimmerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }).toList(),
                )
              ),
              Spacing.vertical(10),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: CommonColors.instance.shimmerHigh),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      spacing: 6,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: CommonColors.instance.shimmerHigh,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                spacing: 5,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    height: 14,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: CommonColors.instance.shimmerHigh,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    height: 15,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: CommonColors.instance.shimmerHigh,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ]
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(12),
                              height: 20,
                              width: 100,
                              decoration: BoxDecoration(
                                color: CommonColors.instance.shimmerHigh,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(12),
                          height: 24,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: CommonColors.instance.shimmerHigh,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ]
                    )
                  )
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
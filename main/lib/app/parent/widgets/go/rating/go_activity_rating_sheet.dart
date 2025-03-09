import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show GetBuilder, Obx;
import 'package:smart/smart.dart';

import 'controllers/go_activity_rating_sheet_controller.dart';
import 'widgets/go_activity_rating_sheet_list_view.dart';

class GoActivityRatingSheet extends StatelessWidget {
  final bool canRate;
  final String activity;
  final GoActivityRatingListUpdated onUpdated;
  final List<GoActivityRating> ratings;

  const GoActivityRatingSheet({
    super.key,
    required this.canRate,
    required this.activity,
    required this.onUpdated,
    required this.ratings
  });


  static void open({
    required bool canRate,
    required String activity,
    required GoActivityRatingListUpdated onUpdated,
    required List<GoActivityRating> ratings
  }) {
    Navigate.bottomSheet(
      sheet: GoActivityRatingSheet(
        canRate: canRate,
        activity: activity,
        onUpdated: onUpdated,
        ratings: ratings
      ),
      route: Navigate.appendRoute("/ratings?for=$activity")
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      uiConfig: UiConfig(
        systemNavigationBarColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      height: MediaQuery.sizeOf(context).height,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      child: GetBuilder<GoActivityRatingSheetController>(
        init: GoActivityRatingSheetController(
          canRate: canRate,
          activity: activity,
          onUpdated: onUpdated,
          ratings: ratings
        ),
        builder: (controller) {
          return Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ModalBottomSheetIndicator(showButton: false, margin: 0),
                    Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GoBack(onTap: () => Navigate.close(closeAll: false), size: 25),
                        Expanded(
                          child: TextBuilder(
                            text: "Activity's experience ratings",
                            color: Theme.of(context).primaryColor,
                            size: Sizing.font(16),
                            weight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: PullToRefresh(
                        onRefreshed: controller.ratingController.refresh,
                        child: GoActivityRatingSheetListView(controller: controller.ratingController),
                      ),
                    )
                  ],
                ),
              ),
              BannerAdLayout(
                expandChild: false,
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(controller.showRatingBuilder) ...[
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(24)
                        ),
                        child: Row(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Obx(() => RatingBar.builder(
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 30,
                                initialRating: controller.state.rating.value,
                                ignoreGestures: controller.state.isRating.value,
                                itemPadding: EdgeInsets.symmetric(horizontal: Sizing.space(4)),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: CommonColors.instance.color,
                                ),
                                onRatingUpdate: (rating) {
                                  controller.state.rating.value = rating;
                                },
                              )),
                            ),
                            Obx(() {
                              if(controller.state.isRating.value) {
                                return Loading.circular(
                                  color: CommonColors.instance.color,
                                  width: 1.5
                                );
                              } else {
                                return IconButton(
                                  onPressed: controller.rate,
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(CommonColors.instance.color.lighten(30)),
                                    overlayColor: WidgetStatePropertyAll(CommonColors.instance.color.lighten(25)),
                                    shape: WidgetStateProperty.all(const CircleBorder()),
                                  ),
                                  tooltip: "Rate this activity",
                                  icon: Icon(
                                    Icons.arrow_upward_rounded,
                                    color: CommonColors.instance.color,
                                    size: Sizing.space(22)
                                  )
                                );
                              }
                            })
                          ],
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: CommonColors.instance.bluish,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Obx(() => TextBuilder(
                          text: controller.state.info.value,
                          size: 12,
                          color: CommonColors.instance.lightTheme
                        ))
                      ),
                    ],
                  ]
                )
              )
            ],
          );
        }
      )
    );
  }
}
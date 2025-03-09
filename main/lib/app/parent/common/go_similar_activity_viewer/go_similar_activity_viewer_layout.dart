import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';
import 'package:get/get.dart' show GetView, Obx;

import 'controllers/go_similar_activity_viewer_controller.dart';

class GoSimilarActivityViewerLayout extends GetView<GoSimilarActivityViewerController> {
  static String route = "/activity/:id/more";

  const GoSimilarActivityViewerLayout({super.key});

  static void open({
    String? activityId,
    GoActivity? activity,
    List<GoActivity> activities = const [],
    bool isOthers = false,
    GoActivityListUpdated? onListUpdated
  }) {
    String? id = activityId ?? activity?.id;

    if(id == null) {
      Navigate.all(PageNotFoundLayout.route);
    } else {
      JsonMap arguments = {
        "activity": activity,
        "activities": activities,
        "is_others": isOthers,
        "on_list_updated": onListUpdated
      };

      Navigate.to("/activity/$id/more", arguments: arguments);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isLoading = controller.state.isLoading.value;
      GoActivity activity = controller.state.activity.value;

      return LayoutWrapper(
        layoutKey: Key(controller.state.isOthers.value ? "other-activity-viewer" : "similar-activity-viewer"),
        appbar: AppBar(
          title: TextBuilder(
            text: controller.title,
            size: Sizing.font(16),
            weight: FontWeight.bold,
            color: Theme.of(context).primaryColor
          ),
        ),
        child: BannerAdLayout(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(isLoading) ...[
                LoadingShimmer(
                  isDarkMode: Database.instance.isDarkTheme,
                  content: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 30,
                    decoration: BoxDecoration(
                      color: CommonColors.instance.shimmerHigh,
                      borderRadius: BorderRadius.circular(12)
                    )
                  )
                )
              ] else if(activity.interest.isNotNull) ...[
                InterestViewer.view(interest: activity.interest!)
              ],
              GoActivityListing(
                showAds: ParentController.data.state.showAds.value,
                controller: controller.activityController,
                id: controller.state.isOthers.value ? "other-activity" : "similar-activity",
              )
            ],
          ),
        )
      );
    });
  }
}
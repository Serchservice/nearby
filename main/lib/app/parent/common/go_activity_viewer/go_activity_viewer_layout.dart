import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

import 'controllers/go_activity_viewer_controller.dart';

class GoActivityViewerLayout extends GetView<GoActivityViewerController> {
  static String get route => "/activity/:id";

  const GoActivityViewerLayout({super.key});

  static void open({GoActivity? activity, String? activityId, required GoActivityUpdated onUpdated}) {
    String id = "";
    if(activity.isNotNull) {
      id = activity!.id;
    } else if(activityId.isNotNull) {
      id = activityId!;
    }

    Map<String, dynamic> arguments = {
      "on_updated": onUpdated
    };
    if(activity.isNotNull) {
      arguments["activity"] = activity;
    }

    if(id != "") {
      Navigate.to("/activity/$id", arguments: arguments);
    } else {
      Navigate.all(PageNotFoundLayout.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isLoading = controller.state.isLoading.value;
      double appBarHeight = controller.state.appbarHeight.value;
      GoActivity activity = controller.state.activity.value;

      List<ButtonView> timelines = [
        ButtonView(icon: Icons.access_time_filled_rounded, header: "${activity.startTime} - ${activity.endTime}"),
        ButtonView(icon: Icons.calendar_month_rounded, header: activity.timestamp),
      ];

      return LayoutWrapper(
        layoutKey: Key("activity-viewer"),
        appbar: AppBar(
          leading: GoBack(
            onTap: () {
              if(Navigate.previousRoute.equals("/") || Navigate.previousRoute.isEmpty) {
                Navigate.all(ParentLayout.route);
              } else {
                Navigate.close(closeAll: false);
              }
            },
            color: CommonColors.instance.lightTheme,
          ),
          title: TextBuilder(
            text: activity.name,
            size: Sizing.font(16),
            weight: FontWeight.bold,
            color: Theme.of(context).primaryColor
          ),
          actions: [
            if(isLoading) ...[
              LoadingShimmer(
                isDarkMode: Database.instance.isDarkTheme,
                content: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: CommonColors.instance.shimmerHigh,
                    shape: BoxShape.circle
                  ),
                )
              )
            ] else ...[
              InfoButton(
                onPressed: () => GoActivityCardSheet.open(
                  activity: activity,
                  showHeader: false,
                  showDetails: false,
                  onUpdated: (GoActivity activity) {
                    controller.state.activity.value = activity;
                    controller.onUpdated(activity);
                  },
                ),
                defaultIcon: Icons.more_vert_rounded,
                defaultIconColor: Theme.of(context).primaryColorLight,
              )
            ],
          ]
        ),
        navigationColor: activity.poll.isNotNull ? CommonColors.instance.bluish : null,
        child: SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(isLoading) ...[
                GoActivityCardLoading(height: appBarHeight)
              ] else ...[
                GoActivityCard(id: "activity-viewer", activity: activity, height: appBarHeight, isClickable: false)
              ],
              Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: timelines.map((ButtonView timeline) => Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      timeline.icon,
                      color: Theme.of(context).primaryColorLight,
                      size: Sizing.font(14),
                    ),
                    TextBuilder(
                      text: timeline.header,
                      color: Theme.of(context).primaryColorLight,
                      size: Sizing.font(12),
                    ),
                  ],
                )).toList()
              ),
              /// MAP VIEW
              if(isLoading) ...[
                LoadingShimmer(
                  isDarkMode: Database.instance.isDarkTheme,
                  content: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 250,
                    color: CommonColors.instance.shimmerHigh,
                  ),
                ),
              ] else if(controller.showMap) ...[
                MapView(
                  origin: Database.instance.address,
                  destination: activity.location,
                  height: 250
                )
              ],
              /// NAVIGATION ACTIONS
              if(isLoading) ...[
                LoadingShimmer(
                  isDarkMode: Database.instance.isDarkTheme,
                  content: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: 6.listGenerator.map((_) => Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: CommonColors.instance.shimmerHigh,
                          borderRadius: BorderRadius.circular(12)
                        )
                      )).toList()
                    )
                  ),
                ),
              ] else if(controller.navigate.isNotNull && activity.isClosed.isFalse) ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: controller.navigate!.options.map((option) {
                      return SizedButton(
                        option: option,
                        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                        onTap: () => controller.navigate!.onClick(option)
                      );
                    }).toList(),
                  ),
                ),
              ],
              /// POLL VIEW
              if(isLoading) ...[
                LoadingShimmer(
                  isDarkMode: Database.instance.isDarkTheme,
                  content: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 180,
                    color: CommonColors.instance.shimmerHigh,
                  ),
                ),
              ] else if(activity.poll.isNotNull) ...[
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: EdgeInsets.all(10),
                  color: CommonColors.instance.bluish.darken(10),
                  child: Column(
                    spacing: 10,
                    children: [
                      SmartPoll(
                        pollEnded: true,
                        metadata: SmartPollMetadata(shouldShow: false),
                        configBuilder: (config, index) {
                          String text = index.equals(0)
                            ? activity.poll!.totalUsersWithSameSharedInterest.prettyFormat
                            : index.equals(2)
                            ? activity.poll!.totalNearbyUsersWithSameSharedInterest.prettyFormat
                            : activity.poll!.totalAttendingUsers.prettyFormat;

                          return config.copyWith(
                            useText: true,
                            text: text,
                            style: TextStyle(color: CommonColors.instance.lightTheme),
                            leadingVotedProgressColor: CommonColors.instance.bluish.lighten(10),
                            votedBackgroundColor: CommonColors.instance.bluish,
                            votedRadius: Radius.circular(48)
                          );
                        },
                        options: [
                          SmartPollOption(
                            id: 0,
                            votes: activity.poll!.totalUsersWithSameSharedInterest,
                            description: "Users with same shared interest"
                          ),
                          SmartPollOption(
                            id: 1,
                            votes: activity.poll!.totalNearbyUsersWithSameSharedInterest,
                            description: "Nearby users with same shared interest"
                          ),
                          SmartPollOption(
                            id: 2,
                            votes: activity.poll!.totalAttendingUsers,
                            description: "Attending users"
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}
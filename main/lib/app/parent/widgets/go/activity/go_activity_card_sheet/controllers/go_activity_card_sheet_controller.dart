import 'package:drive/library.dart';
import 'package:flutter/material.dart' show BuildContext, Container, EdgeInsets, Icons, Padding, Theme, Widget;
import 'package:get/get.dart';
import 'package:smart/smart.dart';

import 'go_activity_card_sheet_state.dart';

class GoActivityCardSheetController extends GetxController {
  final GoActivity activity;
  final GoActivityUpdated onUpdated;

  GoActivityCardSheetController({
    required this.activity,
    required this.onUpdated,
  });

  final state = GoActivityCardSheetState();

  @override
  void onInit() {
    state.activity.value = activity;

    super.onInit();
  }

  List<ButtonView> actions(BuildContext context, bool showDetails) => [
    if(showDetails) ...[
      ButtonView(
        icon: Icons.view_agenda_rounded,
        header: "View details",
        color: Theme.of(context).primaryColor,
        onClick: () => GoActivityViewerLayout.open(activity: activity, onUpdated: onUpdated),
        child: Container(),
      )
    ],
    if(state.activity.value.hasSimilarActivitiesFromOtherCreators) ...[
      ButtonView(
        icon: Icons.devices_other_rounded,
        header: "View similar activities from other creators",
        color: Theme.of(context).primaryColor,
        onClick: () => GoSimilarActivityViewerLayout.open(
          isOthers: true,
          activity: activity,
          activities: state.otherCreatorsActivities.value,
          onListUpdated: (List<GoActivity> activities) {
            state.otherCreatorsActivities.value = activities;
          }
        ),
        child: Container(),
      ),
    ],
    if(state.activity.value.isClosed) ...[
      if(state.activity.value.hasBCap) ...[
        ButtonView(
          icon: Icons.explore_rounded,
          header: "BCap this activity",
          color: Theme.of(context).primaryColor,
          onClick: () => GoBCapViewerLayout.open(
            capId: state.activity.value.bcap,
            cap: state.cap.value.hasBCap ? state.cap.value : null,
            onUpdated: (GoBCap cap) {
              state.cap.value = cap;
            }
          ),
          child: Container(),
        )
      ],
      if(state.activity.value.hasComments || state.activity.value.canComment) ...[
        ButtonView(
          icon: Icons.comment_rounded,
          header: "View and share comments about this activity",
          color: Theme.of(context).primaryColor,
          onClick: () => GoActivityCommentSheet.open(
            canComment: state.activity.value.canComment,
            activity: state.activity.value.id,
            onUpdated: (List<GoActivityComment> comments) {
              state.comments.value = comments;
            },
            comments: state.comments.value
          ),
          child: Container(),
        )
      ],
      if(state.activity.value.hasRatings || state.activity.value.canRate) ...[
        ButtonView(
          icon: Icons.rate_review_rounded,
          header: "View and share ratings about this activity",
          color: Theme.of(context).primaryColor,
          onClick: () => GoActivityRatingSheet.open(
            canRate: state.activity.value.canRate,
            activity: state.activity.value.id,
            onUpdated: (List<GoActivityRating> ratings) {
              state.ratings.value = ratings;
            },
            ratings: state.ratings.value
          ),
          child: Container(),
        )
      ],
    ] else ...[
      ButtonView(
        icon: Icons.connect_without_contact_rounded,
        header: "Share activity with friends",
        color: Theme.of(context).primaryColor,
        onClick: () => GoShare.open<GoActivity>(state.activity.value),
        child: Container(),
      )
    ],
    if(state.activity.value.isCreatedByCurrentUser) ...[
      if(state.activity.value.isOngoing) ...[
        ButtonView(
          icon: Icons.stop_circle_rounded,
          header: "End activity",
          color: CommonColors.instance.error,
          onClick: () async {
            if(state.isEnding.value) return;

            state.isEnding.value = true;
            state.isEnding.value = await ActivityService.instance.end(
              activity: state.activity.value,
              onUpdated: (GoActivity activity) {
                state.activity.value = activity;
                onUpdated(activity);
              }
            );
          },
          child: loading(state.isEnding.value),
        )
      ],
      if(state.activity.value.isPending) ...[
        ButtonView(
          icon: Icons.start_rounded,
          header: "Start activity",
          color: CommonColors.instance.bluish,
          onClick: () async {
            if(state.isStarting.value) return;

            state.isStarting.value = true;
            state.isStarting.value = await ActivityService.instance.start(
              activity: state.activity.value,
              onUpdated: (GoActivity activity) {
                state.activity.value = activity;
                onUpdated(activity);
              }
            );
          },
          child: loading(state.isStarting.value),
        )
      ],
      if(state.activity.value.hasBCap.isFalse && state.activity.value.isClosed) ...[
        ButtonView(
          icon: Icons.explore_rounded,
          header: "Share your experience on this activity",
          color: Theme.of(context).primaryColor,
          onClick: () => GoBCapCreator.open(state.activity.value),
          child: Container(),
        )
      ],
      ButtonView(
        icon: Icons.delete_sweep_rounded,
        header: "Delete activity",
        color: CommonColors.instance.error,
        onClick: () => GoDelete.open<GoActivity>(state.activity.value),
        child: Container(),
      ),
    ] else ...[
      if(state.activity.value.isClosed.isFalse) ...[
        ButtonView(
          icon: state.activity.value.hasResponded ? Icons.eco_sharp : Icons.check_circle_sharp,
          header: "I will be attending",
          color: state.activity.value.hasResponded ? CommonColors.instance.bluish : Theme.of(context).primaryColor,
          onClick: () async {
            ActivityService.instance.attend(
              activity: state.activity.value,
              onUpdated: (GoActivity activity) {
                state.activity.value = activity;
                onUpdated(activity);
              }
            );
          },
          child: Container(),
        ),
      ],
      if(state.activity.value.hasSimilarActivitiesFromCreator) ...[
        ButtonView(
          icon: Icons.next_plan_rounded,
          header: "View similar activities from ${activity.user?.firstName ?? "creator"}",
          color: Theme.of(context).primaryColor,
          onClick: () => GoSimilarActivityViewerLayout.open(
            isOthers: false,
            activity: activity,
            activities: state.creatorActivities.value,
            onListUpdated: (List<GoActivity> activities) {
              state.creatorActivities.value = activities;
            }
          ),
          child: Container(),
        ),
      ],
    ],
  ];

  Widget loading(bool value) {
    if(value) {
      return Padding(
        padding: const EdgeInsets.only(right: 2),
        child: Loading.circular(color: Get.theme.primaryColor, width: 1),
      );
    } else {
      return Container();
    }
  }
}
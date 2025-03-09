import 'package:drive/library.dart';
import 'package:flutter/material.dart' show PageController, Icons, ScrollPosition, Curves;
import 'package:get/get.dart';
import 'package:smart/smart.dart';

import 'go_bcap_card_state.dart';

class GoBCapCardController extends GetxController {
  final GoBCap cap;
  GoBCapCardController({required this.cap});

  final state = GoBCapCardState();

  final PageController itemController = PageController();

  @override
  void onInit() {
    state.cap.value = cap;
    state.totalContentCount.value = contents.length;

    super.onInit();
  }

  bool get show => state.cap.value.files.isNotEmpty;

  List<GoFile> get contents => state.cap.value.files;

  List<SelectedMedia> get resources => contents.map((GoFile image) => SelectedMedia(
    path: image.file,
    media: image.type.toMediaType
  )).toList();

  List<ButtonView> get buttons => [
    ButtonView(
      icon: Icons.star_rate_outlined,
      header: state.cap.value.totalRatings,
      color: CommonColors.instance.lightTheme,
      onClick: () => GoActivityRatingSheet.open(
        canRate: state.cap.value.canRate,
        activity: state.cap.value.activity,
        onUpdated: (List<GoActivityRating> ratings) {
          state.ratings.value = ratings;
        },
        ratings: state.ratings.value
      )
    ),
    ButtonView(
      icon: Icons.comment_outlined,
      header: state.cap.value.totalComments,
      color: CommonColors.instance.lightTheme,
      onClick: () => GoActivityCommentSheet.open(
        canComment: state.cap.value.canComment,
        activity: state.cap.value.activity,
        onUpdated: (List<GoActivityComment> comments) {
          state.comments.value = comments;
        },
        comments: state.comments.value
      )
    ),
    ButtonView(
      icon: Icons.share_outlined,
      header: "Share",
      color: CommonColors.instance.lightTheme,
      onClick: () => GoShare.open<GoBCap>(state.cap.value)
    ),
    if(state.cap.value.isCreatedByCurrentUser) ...[
      ButtonView(
        icon: Icons.delete_sweep_outlined,
        color: CommonColors.instance.error,
        onClick: () => GoDelete.open<GoBCap>(state.cap.value),
      ),
    ],
    ButtonView(
      icon: Icons.view_carousel_outlined,
      color: CommonColors.instance.bluish,
      onClick: () => GoActivityViewerLayout.open(
        activityId: state.cap.value.activity,
        activity: state.activity.value.hasActivity ? state.activity.value : null,
        onUpdated: (GoActivity activity) {
          state.activity.value = activity;
        }
      )
    ),
  ];

  @override
  void onReady() {
    itemController.addListener(_itemListener);

    super.onReady();
  }

  void _itemListener() {
    if(itemController.hasClients.isFalse) {
      return;
    }

    ScrollPosition position = itemController.position;
    double width = Get.width - 32;
    if (position.hasPixels) {
      onPageChanged((position.pixels / width).round());
    }
  }

  void onPageChanged(int value) {
    state.currentContentIndex.value = value;
  }

  void previous() {
    state.currentContentIndex.value--;
    itemController.animateToPage(
      state.currentContentIndex.value,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void next() {
    state.currentContentIndex.value++;
    itemController.animateToPage(
      state.currentContentIndex.value,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    itemController.dispose();

    super.onClose();
  }
}
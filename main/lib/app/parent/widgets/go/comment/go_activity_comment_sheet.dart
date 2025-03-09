import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show GetBuilder, Obx;
import 'package:smart/smart.dart';

import 'controllers/go_activity_comment_sheet_controller.dart';
import 'widgets/go_activity_comment_sheet_listview.dart';

class GoActivityCommentSheet extends StatelessWidget {
  final bool canComment;
  final String activity;
  final GoActivityCommentListUpdated onUpdated;
  final List<GoActivityComment> comments;

  const GoActivityCommentSheet({
    super.key,
    required this.canComment,
    required this.activity,
    required this.onUpdated,
    required this.comments
  });

  static void open({
    required bool canComment,
    required String activity,
    required GoActivityCommentListUpdated onUpdated,
    required List<GoActivityComment> comments
  }) {
    Navigate.bottomSheet(
      sheet: GoActivityCommentSheet(
        canComment: canComment,
        activity: activity,
        onUpdated: onUpdated,
        comments: comments
      ),
      route: Navigate.appendRoute("/comments?for=$activity")
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
      child: GetBuilder<GoActivityCommentSheetController>(
        init: GoActivityCommentSheetController(
          canComment: canComment,
          activity: activity,
          onUpdated: onUpdated,
          comments: comments
        ),
        builder: (controller) {
          return Stack(
            children: [
              Column(
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
                          text: "Activity's experience comments",
                          color: Theme.of(context).primaryColor,
                          size: Sizing.font(16),
                          weight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: PullToRefresh(
                      onRefreshed: controller.commentController.refresh,
                      child: GoActivityCommentSheetListView(controller: controller.commentController),
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BannerAdLayout(
                  expandChild: false,
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(controller.showCommentField) ...[
                        Row(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Field(
                                hint: "It was fun doing such a wonderful activity",
                                replaceHintWithLabel: false,
                                fillColor: Theme.of(context).appBarTheme.backgroundColor,
                                inputConfigBuilder: (config) => config.copyWith(
                                  labelColor: Theme.of(context).primaryColor,
                                  labelSize: 14
                                ),
                                borderRadius: 24,
                                inputDecorationBuilder: (dec) => dec.copyWith(
                                  enabledBorderSide: BorderSide(color: CommonColors.instance.hint),
                                  focusedBorderSide: BorderSide(color: Theme.of(context).primaryColor),
                                ),
                                onTapOutside: (activity) => CommonUtility.unfocus(context),
                                controller: controller.textController,

                              ),
                            ),
                            Obx(() {
                              if(controller.state.isCommenting.value) {
                                return Loading.circular(
                                  color: CommonColors.instance.color,
                                  width: 1.5
                                );
                              } else {
                                return IconButton(
                                  onPressed: controller.comment,
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(CommonColors.instance.color.lighten(30)),
                                    overlayColor: WidgetStatePropertyAll(CommonColors.instance.color.lighten(25)),
                                    shape: WidgetStateProperty.all(const CircleBorder()),
                                  ),
                                  tooltip: "Comment",
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
                ),
              )
            ],
          );
        }
      )
    );
  }
}
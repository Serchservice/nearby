import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show GetX;
import 'package:smart/smart.dart';

import 'controllers/go_bcap_card_controller.dart';

class GoBCapCard extends StatelessWidget {
  final GoBCap cap;
  final String id;
  final double? height;
  final double? width;
  final bool isClickable;

  const GoBCapCard({
    super.key,
    required this.cap,
    this.height,
    this.width,
    this.id = "",
    this.isClickable = false,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveUtil responsive = ResponsiveUtil(context);
    double displayHeight = height ?? MediaQuery.sizeOf(context).height;
    double displayWidth = width ?? MediaQuery.sizeOf(context).width;

    return SizedBox(
      height: displayHeight,
      width: displayWidth,
      child: GetX<GoBCapCardController>(
        tag: id.isNotEmpty ? "$id-${cap.id}" : cap.id,
        init: GoBCapCardController(cap: cap),
        builder: (controller) {
          GoBCap cap = controller.state.cap.value;
          BCapController capController = BCapController.data;

          double position = 5;
          double spacer = 10;

          Widget mediaView(SelectedMedia media) {
            if(media.media.isPhoto) {
              return Image(
                image: AssetUtility.image(media.path),
                fit: BoxFit.cover,
                width: displayWidth,
                height: displayHeight,
              );
            } else {
              if(isClickable) {
                return MultimediaVideoPlayer.box(
                  video: media.path,
                  width: displayWidth,
                  height: displayHeight,
                  showControl: false,
                  autoPlay: false,
                );
              } else {
                return MultimediaVideoPlayer.screen(
                  video: media.path,
                  width: displayWidth,
                  height: displayHeight,
                  showControl: false,
                  autoPlay: true,
                  loopContinuously: capController.state.continuousLooping.value,
                  useSize: responsive.isDesktop,
                );
              }
            }
          }

          if(height.isNotNull && isClickable) {
            SelectedMedia media = controller.resources.first;

            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () => GoBCapViewerLayout.open(
                  cap: cap,
                  capId: cap.id,
                  onUpdated: (GoBCap cap) {
                    controller.state.cap.value = cap;
                  }
                ),
                child: mediaView(media)
              )
            );
          }

          Color commonColor = CommonColors.instance.lightTheme;
          bool canShowDots = controller.resources.length > 1;

          Widget child = ConstrainedBox(
            constraints: BoxConstraints(maxHeight: displayHeight, maxWidth: displayWidth),
            child: Stack(
              children: [
                PageView(
                  controller: controller.itemController,
                  onPageChanged: controller.onPageChanged,
                  children: controller.resources.map(mediaView).toList(),
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
                            if(cap.interest.isNotNull) ...[
                              InterestViewer.view(interest: cap.interest!)
                            ],
                            Row(
                              spacing: spacer,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextBuilder(
                                    text: cap.name,
                                    size: Sizing.font(18),
                                    weight: FontWeight.bold,
                                    color: commonColor
                                  ),
                                ),
                                if(cap.hasRating) ...[
                                  RatingIcon(
                                    rating: cap.rating,
                                    config: RatingIconConfig(),
                                    color: commonColor,
                                  )
                                ]
                              ],
                            ),
                            TextBuilder(
                              text: cap.description,
                              size: Sizing.font(12),
                              color: commonColor
                            ),
                            if(canShowDots) ...[
                              Row(
                                spacing: 2,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: controller.resources.length.listGenerator.map((int index) {
                                  bool isCurrent = controller.state.currentContentIndex.value == index;

                                  return Container(
                                    width: 20,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: isCurrent ? CommonColors.instance.color : commonColor,
                                      borderRadius: BorderRadius.circular(6)
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                            Spacing.vertical(2),
                          ],
                        ),
                      ),
                      Column(
                        spacing: spacer,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: controller.buttons.map((ButtonView button) {
                          bool show = button.header.isNotEmpty;

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: button.onClick,
                                style: ButtonStyle(
                                  backgroundColor: show ? null : WidgetStatePropertyAll(button.color.lighten(30)),
                                ),
                                icon: Icon(button.icon, color: button.color),
                              ),
                              if(show) ...[
                                TextBuilder(
                                  text: button.header,
                                  size: Sizing.font(12),
                                  weight: FontWeight.bold,
                                  color: button.color
                                )
                              ],
                            ]
                          );
                        }).toList()
                      )
                    ],
                  )
                )
              ]
            ),
          );

          if(responsive.isDesktop) {
            return Stack(
              children: [
                Container(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: child,
                  ),
                ),
                if(canShowDots && controller.state.currentContentIndex.value.notEquals(0)) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: InfoButton(
                        defaultIcon: Icons.keyboard_arrow_left,
                        tip: "Previous",
                        padding: WidgetStatePropertyAll(EdgeInsets.zero),
                        backgroundColor: WidgetStatePropertyAll(CommonColors.instance.bluish.lighten(43)),
                        defaultIconColor: CommonColors.instance.bluish,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: WidgetStatePropertyAll(Size(50, 50)),
                        onPressed: controller.previous,
                      ),
                    )
                  )
                ],
                if(canShowDots && controller.state.currentContentIndex.value.notEquals(controller.state.totalContentCount.value)) ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: InfoButton(
                        defaultIcon: Icons.keyboard_arrow_right,
                        tip: "Next",
                        padding: WidgetStatePropertyAll(EdgeInsets.zero),
                        backgroundColor: WidgetStatePropertyAll(CommonColors.instance.bluish.lighten(43)),
                        defaultIconColor: CommonColors.instance.bluish,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: WidgetStatePropertyAll(Size(50, 50)),
                        onPressed: controller.next,
                      ),
                    )
                  )
                ]
              ],
            );
          } else {
            return child;
          }
        }
      )
    );
  }
}
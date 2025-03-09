import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:smart/smart.dart' show ColorExtensions, RatingIcon,
  RatingIconConfig, Sizing, Spacing, TExtensions, TextBuilder;

import 'controllers/go_activity_card_controller.dart';

class GoActivityCard extends StatelessWidget {
  final GoActivity activity;
  final bool isClickable;
  final double? height;
  final double? width;
  final MainAxisAlignment? dotAlignment;
  final bool applyPadding;
  final String id;

  const GoActivityCard({
    super.key,
    required this.activity,
    this.height,
    this.width,
    this.dotAlignment,
    this.isClickable = true,
    this.applyPadding = true,
    this.id = "",
  });

  @override
  Widget build(BuildContext context) {
    return GetX<GoActivityCardController>(
      tag: id.isNotEmpty ? "$id-${activity.id}" : activity.id,
      init: GoActivityCardController(activity: activity),
      builder: (GoActivityCardController controller) {
        GoActivity activity = controller.state.activity.value;
        double contentWidth = width ?? MediaQuery.sizeOf(context).width;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: height ?? controller.contentHeight,
                    maxWidth: contentWidth,
                  ),
                  child: CarouselView(
                    controller: controller.carouselController,
                    itemExtent: double.infinity,
                    padding: EdgeInsets.zero,
                    itemSnapping: true,
                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero),
                    onTap: (index) => GoActivityCardSheet.open(
                      activity: activity,
                      onUpdated: (GoActivity activity) {
                        controller.state.activity.value = activity;
                      },
                    ),
                    children: controller.resources.map((SelectedMedia image) {
                      return Image(
                        image: AssetUtility.image(image.path),
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  ),
                ),
                if(activity.interest.isNotNull) ...[
                  Positioned(
                    left: 5,
                    bottom: 5,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: CommonColors.instance.bluish,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBuilder(
                            text: activity.interest!.title,
                            size: Sizing.font(12),
                            color: CommonColors.instance.lightTheme,
                            weight: FontWeight.bold,
                            flow: TextOverflow.ellipsis
                          ),
                          TextBuilder(
                            text: activity.interest!.category,
                            size: 9,
                            autoSize: false,
                            color: CommonColors.instance.lightTheme,
                            flow: TextOverflow.ellipsis
                          ),
                        ],
                      )
                    )
                  )
                ],
                if(activity.hasResponded) ...[
                  Positioned(
                    right: 5,
                    bottom: 5,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CommonColors.instance.bluish.lighten(25),
                      ),
                      child: Icon(
                        Icons.eco_sharp,
                        color: CommonColors.instance.bluish,
                        size: 24
                      )
                    )
                  )
                ]
              ],
            ),
            if(controller.images.length > 1) ...[
              Spacing.vertical(6),
              Row(
                spacing: 2,
                mainAxisAlignment: dotAlignment ?? MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(controller.images.length, (index) {
                  bool isCurrent = controller.state.currentImageIndex.value == index;

                  return Container(
                    width: 20,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isCurrent ? Theme.of(context).primaryColor : Theme.of(context).appBarTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(6)
                    ),
                  );
                }),
              ),
            ],
            Padding(
              padding: applyPadding ? EdgeInsets.symmetric(horizontal: 2) : EdgeInsets.zero,
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: activity.colored,
                        ),
                        child: TextBuilder(
                          text: controller.timing,
                          autoSize: false,
                          size: 12,
                          color: CommonColors.instance.lightTheme,
                          weight: FontWeight.bold,
                          flow: TextOverflow.ellipsis
                        )
                      ),
                      Spacing.flexible(),
                      if(controller.attendingUserAvatars.isNotEmpty) ...[
                        Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: StackedAvatars(
                            avatars: controller.attendingUserAvatars,
                            totalAvatarsInView: 10,
                            avatarSize: Sizing.font(25),
                          )
                        )
                      ],
                    ]
                  ),
                  Row(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextBuilder(
                          text: activity.name,
                          color: Theme.of(context).primaryColor,
                          size: Sizing.font(18),
                          weight: FontWeight.bold,
                        ),
                      ),
                      if(activity.isClosed && activity.hasRating) ...[
                        RatingIcon(
                          rating: activity.rating,
                          config: RatingIconConfig(),
                          color: Theme.of(context).primaryColor,
                        )
                      ]
                    ],
                  ),
                  if(activity.user.isNotNull) ...[
                    Row(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Avatar(radius: 10, avatar: activity.user!.avatar),
                        Expanded(
                          child: TextBuilder(
                            text: activity.user!.fullName,
                            color: Theme.of(context).primaryColorLight,
                            size: Sizing.font(14),
                          ),
                        ),
                      ],
                    )
                  ],
                ]
              ),
            )
          ],
        );
      }
    );
  }
}
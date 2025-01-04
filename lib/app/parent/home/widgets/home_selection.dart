import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class HomeSelection extends StatelessWidget {
  final HomeController controller;

  const HomeSelection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(controller.hasDetails) {
        return Column(
          children: [
            Swiper(
              onRightSwipe: (d) => controller.clearSelection(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  child: InkWell(
                    onTap: () => controller.search(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(controller.hasSelectedLocation) ...[
                          Padding(
                            padding: EdgeInsets.all(Sizing.space(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SText(
                                  text: "Your Location",
                                  size: Sizing.font(12),
                                  color: CommonColors.hint
                                ),
                                LocationView(address: controller.state.selectedAddress.value),
                              ],
                            ),
                          ),
                        ],
                        if(controller.hasDetails) ...[
                          Divider(color: Theme.of(context).primaryColorLight)
                        ],
                        if(controller.category() != null) ...[
                          Padding(
                            padding: EdgeInsets.all(Sizing.space(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SText(
                                  text: "Selected category",
                                  size: Sizing.font(12),
                                  color: CommonColors.hint
                                ),
                                SText(
                                  text: controller.category()!.title,
                                  size: Sizing.font(14),
                                  color: Theme.of(context).primaryColor
                                ),
                                SText(
                                  text: controller.state.category.value.title,
                                  size: Sizing.font(12),
                                  color: Theme.of(context).primaryColor
                                ),
                              ],
                            ),
                          ),
                          Divider(color: Theme.of(context).primaryColorLight),
                        ],
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SText(
                                text: "Note (Swipe right to dismiss ${controller.canShowButton ? "or tap to continue" : ""})",
                                size: Sizing.font(12),
                                color: CommonColors.hint
                              ),
                              Spacer(),
                              if(controller.canShowButton) ...[
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: Sizing.space(24),
                                  color: Theme.of(context).primaryColorLight
                                )
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        return Container();
      }
    });
  }
}
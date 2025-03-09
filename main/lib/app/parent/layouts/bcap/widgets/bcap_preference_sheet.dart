import 'package:drive/app/library.dart';
import 'package:drive/library.dart' show Navigate, Switcher;
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Obx;
import 'package:smart/smart.dart' show GoBack, ModalBottomSheet, ModalBottomSheetIndicator, Sizing, Spacing, TextBuilder, UiConfig;

class BCapPreferenceSheet extends StatelessWidget {
  const BCapPreferenceSheet({super.key});

  static void open() {
    Navigate.bottomSheet(
      sheet: BCapPreferenceSheet(),
      route: Navigate.appendRoute("/bcap/preferences"),
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    BCapController controller = BCapController.data;

    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      uiConfig: UiConfig(
        systemNavigationBarColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModalBottomSheetIndicator(showButton: false, margin: 0),
          GoBack(onTap: () => Navigate.close(closeAll: false), size: 25),
          TextBuilder(
            text: "Control how you view BCaps",
            color: Theme.of(context).primaryColor,
            size: Sizing.font(22),
            weight: FontWeight.bold
          ),
          Spacing.vertical(10),
          Obx(() {
            return Row(
              spacing: 30,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextBuilder(
                        text: "Continuous looping",
                        size: Sizing.font(14),
                        color: Theme.of(context).primaryColor
                      ),
                      TextBuilder(
                        text: "Never stop playing any bcap video in view.",
                        size: Sizing.font(12),
                        color: Theme.of(context).primaryColorLight
                      ),
                    ],
                  ),
                ),
                Switcher(
                  onChanged: controller.onContinuousLoopingChanged,
                  value: controller.state.continuousLooping.value
                )
              ],
            );
          }),
        ],
      ),
    );
  }
}
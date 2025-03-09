import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show GetX;
import 'package:smart/smart.dart';

import 'controllers/go_activity_card_sheet_controller.dart';

class GoActivityCardSheet extends StatelessWidget {
  final GoActivity activity;
  final GoActivityUpdated onUpdated;
  final bool showHeader;
  final bool showDetails;

  const GoActivityCardSheet({
    super.key,
    required this.activity,
    required this.onUpdated,
    required this.showHeader,
    required this.showDetails,
  });

  static void open({
    required GoActivity activity,
    required GoActivityUpdated onUpdated,
    bool showHeader = true,
    bool showDetails = true
  }) {
    Navigate.bottomSheet(
      sheet: GoActivityCardSheet(
        activity: activity,
        onUpdated: onUpdated,
        showHeader: showHeader,
        showDetails: showDetails
      ),
      route: Navigate.appendRoute("/options"),
      background: Colors.transparent,
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      padding: EdgeInsets.zero,
      uiConfig: UiConfig(
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Database.instance.isLightTheme ? Brightness.dark : Brightness.light,
      ),
      child: GetX<GoActivityCardSheetController>(
        init: GoActivityCardSheetController(
          activity: activity,
          onUpdated: onUpdated
        ),
        builder: (controller) {
          GoActivity activity = controller.state.activity.value;
          List<ButtonView> options = controller.actions(context, showDetails);

          List<ButtonView> timelines = [
            ButtonView(icon: Icons.access_time_filled_rounded, header: "${activity.startTime} - ${activity.endTime}"),
            ButtonView(icon: Icons.calendar_month_rounded, header: activity.timestamp),
          ];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if(showHeader) ...[
                  Container(
                    color: Theme.of(context).textSelectionTheme.selectionColor,
                    child: Column(
                      children: [
                        ModalBottomSheetIndicator(
                          showButton: PlatformEngine.instance.isWeb,
                          color: CommonColors.instance.darkTheme2,
                          backgroundColor: CommonColors.instance.lightTheme2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            spacing: 30,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextBuilder(
                                      text: activity.name,
                                      size: Sizing.font(16),
                                      weight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                      flow: TextOverflow.ellipsis
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: activity.colored.lighten(40),
                                      ),
                                      child: TextBuilder(
                                        text: activity.status,
                                        autoSize: false,
                                        size: 12,
                                        color: activity.colored,
                                        weight: FontWeight.bold,
                                        flow: TextOverflow.ellipsis
                                      )
                                    )
                                  ],
                                ),
                              ),
                              TextBuilder(
                                text: activity.interest?.emoji ?? "",
                                size: Sizing.font(16),
                                weight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                flow: TextOverflow.ellipsis
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ] else ...[
                  ModalBottomSheetIndicator(
                    showButton: PlatformEngine.instance.isWeb,
                    color: CommonColors.instance.darkTheme2,
                    backgroundColor: CommonColors.instance.lightTheme2,
                  ),
                ],
                if(showHeader) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
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
                  )
                ],
                ...options.map((ButtonView option) {
                  return SmartButton(
                    tab: option,
                    color: option.color,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    notification: option.child,
                    needNotification: option.child != null,
                    onTap: () {
                      if(option.onClick.isNotNull) {
                        option.onClick!();
                      }
                    },
                  );
                })
              ],
            ),
          );
        }
      )
    );
  }
}
import 'package:drive/app/library.dart';
import 'package:flutter/material.dart';
import 'package:drive/library.dart' show CommonColors, Navigate, PreferenceSwitcher;
import 'package:get/get.dart' show Obx;
import 'package:smart/smart.dart' show ButtonView, GoBack, InteractiveButton, LoadingShimmer, ModalBottomSheet, ModalBottomSheetIndicator, Sizing, Spacing, TextBuilder, UiConfig;

class LocationViewer extends StatelessWidget {
  const LocationViewer({super.key});

  static void open() {
    Navigate.bottomSheet(
      sheet: LocationViewer(),
      route: Navigate.appendRoute("/current-location"),
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    ParentController controller = ParentController.data;

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GoBack(onTap: () => Navigate.close(closeAll: false), size: 25),
              Expanded(
                child: TextBuilder(
                  text: "Your current location",
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(22),
                  weight: FontWeight.bold
                ),
              ),
            ],
          ),
          Spacing.vertical(10),
          Obx(() {
            if(controller.state.isGettingCurrentLocation.value) {
              return LoadingShimmer(
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: CommonColors.instance.shimmerHigh
                      ),
                    ),
                    Spacing.vertical(6),
                    Container(
                      height: 12,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: CommonColors.instance.shimmerHigh
                      ),
                    )
                  ],
                )
              );
            } else if(controller.showSwitch) {
              return Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocationView(address: controller.state.currentLocation.value),
                  PreferenceSwitcher(
                    view: ButtonView(
                      header: "Use current location",
                      body: "Tap to view your current location"
                    ),
                    onChange: controller.onCurrentLocationChanged,
                    value: controller.state.useCurrentLocation.value
                  ),
                  InteractiveButton(
                    text: "Refresh location",
                    borderRadius: 24,
                    width: MediaQuery.sizeOf(context).width,
                    textSize: Sizing.font(14),
                    buttonColor: CommonColors.instance.color,
                    textColor: CommonColors.instance.lightTheme,
                    onClick: controller.getCurrentLocation,
                  )
                ],
              );
            }

            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
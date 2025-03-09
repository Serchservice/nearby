import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class NavigationSheet<T> extends StatelessWidget {
  final T response;
  final Address pickup;

  const NavigationSheet({super.key, required this.response, required this.pickup});

  static void open<T>(T response, Address pickup) {
    String route = "";
    if(response.instanceOf<SearchShopResponse>()) {
      SearchShopResponse shop = response as SearchShopResponse;
      route = "/drive?to=${shop.shop.address}&latitude=${shop.shop.latitude}&longitude=${shop.shop.longitude}";
    } else if(response.instanceOf<GoActivity>() && (response as GoActivity).location.isNotNull) {
      GoActivity shop = response as GoActivity;
      route = "/drive?to=${shop.location!.place}&latitude=${shop.location!.latitude}&longitude=${shop.location!.longitude}";
    }

    Navigate.bottomSheet(
      sheet: NavigationSheet(response: response, pickup: pickup),
      route: Navigate.appendRoute(route),
      background: Colors.transparent,
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      padding: EdgeInsets.zero,
      useSafeArea: (config) => config.copyWith(top: true),
      sheetPadding: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(24),
      child: GetBuilder<NavigationSheetController>(
        init: NavigationSheetController(response: response, pickup: pickup),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(Sizing.space(2)),
                    margin: EdgeInsets.all(Sizing.space(6)),
                    width: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(16)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: TextBuilder(
                      text: "Choose the navigation that works for you",
                      size: Sizing.font(16),
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                ),
                Spacing.vertical(20),
                _loadList(context, controller),
              ],
            )
          );
        }
      )
    );
  }

  Widget _loadList(BuildContext context, NavigationSheetController controller) {
    return Obx(() {
      if(controller.state.isLoading.value) {
        return LoadingShimmer(
          content: ListView.builder(
            itemCount: 3,
            padding: EdgeInsets.all(Sizing.space(10)),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.sizeOf(context).width,
                margin: EdgeInsets.only(bottom: Sizing.space(10)),
                height: 50,
                color: CommonColors.instance.shimmerHigh,
              );
            }
          )
        );
      } else if(controller.state.maps.isNotEmpty) {
        return ListView.builder(
          itemCount: controller.state.maps.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            bool isLast = controller.state.maps.length - 1 == index;
            var map = controller.state.maps[index];

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => controller.onSelect(map),
                child: Container(
                  padding: EdgeInsets.all(Sizing.space(12)),
                  margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(PlatformEngine.instance.isWeb) ...[
                        Image.asset(map.icon, height: 30.0, width: 30.0)
                      ] else ...[
                        SvgPicture.asset(map.icon, height: 30.0, width: 30.0)
                      ],
                      Spacing.horizontal(10),
                      Expanded(
                        child: TextBuilder(
                          text: map.mapName,
                          size: Sizing.font(15),
                          color: Theme.of(context).primaryColor
                        )
                      ),
                    ],
                  ),
                )
              )
            );
          }
        );
      } else {
        return Center(
          child: TextBuilder.center(
            text: "We couldn't find any installed map application in your device.",
            size: Sizing.font(14),
            color: Theme.of(context).primaryColorLight
          ),
        );
      }
    });
  }
}
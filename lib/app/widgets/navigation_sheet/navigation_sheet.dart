import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:drive/library.dart';

class NavigationSheet extends StatelessWidget {
  final SearchShopResponse shop;
  const NavigationSheet({super.key, required this.shop});

  static void open(SearchShopResponse shop) => Navigate.bottomSheet(
    sheet: NavigationSheet(shop: shop),
    route: "/drive?to=${shop.shop.address}&latitude=${shop.shop.latitude}&longitude=${shop.shop.longitude}",
    background: Colors.transparent,
    isScrollable: true
  );

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      padding: EdgeInsets.zero,
      safeArea: true,
      margin: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(24),
      child: GetBuilder<NavigationSheetController>(
        init: NavigationSheetController(shop: shop),
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
                    child: SText(
                      text: "Choose the navigation that works for you",
                      size: Sizing.font(16),
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                color: CommonColors.shimmerHigh,
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
                      SvgPicture.asset(map.icon, height: 30.0, width: 30.0),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SText(
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
          child: SText.center(
            text: "We couldn't find any installed map application in your device.",
            size: Sizing.font(14),
            color: Theme.of(context).primaryColorLight
          ),
        );
      }
    });
  }
}
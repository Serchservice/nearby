import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeLayout extends GetResponsiveView<HomeController> {
  static String get route => "/";

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      layoutKey: Key("Home"),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => RouteNavigator.openWeb(header: "Serchservice", url: Constants.baseWeb),
                child: Image.asset(
                  Assets.logoLogo,
                  width: 100,
                  height: 60,
                  fit: BoxFit.contain,
                  color: Theme.of(context).primaryColor
                ),
              ),
            ],
          ),
          Expanded(
            child: Obx(() {
              CategorySection selected = controller.state.category.value;

              return PullToRefresh(
                onRefreshed: controller.getCurrentLocationAndPromotionalItem,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeCurrentLocation(
                          isLoading: controller.state.isGettingCurrentLocation.value,
                          address: controller.state.currentLocation.value,
                        ),
                        SizedBox(height: 10),
                        ...controller.fields(selected).asMap().entries.map((item) {
                          return HomeSearchStep(
                            custom: item.value,
                            height: 38,
                            showBottom: item.key == 0,
                          );
                        }),
                        SizedBox(height: 10),
                        if(controller.showSwitch) ...[
                          PreferenceSwitcher(
                            view: ButtonView(
                              header: "Use current location",
                              body: "Fast-forward your search requests using current location"
                            ),
                            onChange: controller.onCurrentLocationChanged,
                            value: controller.state.useCurrentLocation.value
                          ),
                          SizedBox(height: 10),
                        ],
                        HomeSelection(controller: controller),
                        ...controller.items().map((item) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              SText(
                                text: item.title,
                                size: Sizing.font(20),
                                color: Theme.of(context).primaryColor,
                                weight: FontWeight.bold,
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 180,
                                child: GridView.builder(
                                  scrollDirection: Axis.horizontal,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    crossAxisSpacing: 8,
                                    mainAxisExtent: 300,
                                    mainAxisSpacing: 8,
                                  ),
                                  shrinkWrap: true,
                                  itemCount: item.sections.length,
                                  itemBuilder: (context, index) {
                                    CategorySection section = item.sections[index];

                                    return HomeQuickOption(section: section, onClicked: controller.handleQuickOption);
                                  },
                                ),
                              )
                            ],
                          );
                        }),
                        const SizedBox(height: 20)
                      ]
                    ),
                  ),
                ),
              );
            })
          ),
          BannerAdWidget(),
        ],
      )
    );
  }
}
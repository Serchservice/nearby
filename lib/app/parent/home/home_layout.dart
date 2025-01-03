import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeLayout extends GetResponsiveView<HomeController> {
  static String get route => "/";

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
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
                  width: 120,
                  height: 70,
                  fit: BoxFit.contain,
                  color: Theme.of(context).primaryColor
                ),
              ),
            ],
          ),
          Expanded(
            child: Obx(() {
              CategorySection selected = controller.state.category.value;

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...controller.fields(selected).map((item) {
                        return HomeSearchStep(
                          custom: item,
                          height: 30,
                          showBottom: controller.fields(selected).length - 1 != controller.fields(selected).indexOf(item),
                        );
                      }),
                      HomeSelection(controller: controller),
                      ...controller.items.map((item) {
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
              );
            })
          ),
          BannerAdWidget(),
        ],
      )
    );
  }
}
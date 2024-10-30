import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeLayout extends GetResponsiveView<HomeController> {
  static String get route => "/";

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return MainLayout(
        endDrawer: AppDrawer(),
        floatingButton: controller.canShowButton ? FloatingActionButton.small(
          backgroundColor: Theme.of(context).primaryColorLight,
          onPressed: () => controller.search(),
          child: Icon(
            Icons.manage_search_rounded,
            color: Theme.of(context).scaffoldBackgroundColor
          ),
        ) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: Sizing.space(12)),
              color: Theme.of(context).appBarTheme.backgroundColor,
              width: MediaQuery.sizeOf(context).width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => RouteNavigator.openWeb(header: "Serchservice", url: Constants.baseWeb),
                    child: Image.asset(
                      Assets.logoSplashWhite,
                      width: 80,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      if(mainLayoutKey.currentState!.isEndDrawerOpen) {
                        mainLayoutKey.currentState!.closeEndDrawer();
                      } else {
                        mainLayoutKey.currentState!.openEndDrawer();
                      }
                    },
                    icon: Icon(Icons.menu_rounded, color: Theme.of(context).primaryColor)
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: Sizing.space(12),
                        right: Sizing.space(12),
                        bottom: Sizing.space(12)
                      ),
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      width: MediaQuery.sizeOf(context).width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SText(
                            text: CommonUtility.greeting(),
                            size: Sizing.font(20),
                            weight: FontWeight.w700,
                            color: Theme.of(context).primaryColor
                          ),
                          const SizedBox(height: 10),
                          FakeField(
                            buttonText: "Search",
                            searchText: "What is your pickup address?",
                            color: Theme.of(context).textSelectionTheme.selectionColor,
                            needPadding: false,
                            onTap: () => Navigate.to(LocationSearchLayout.route),
                          ),
                          const SizedBox(height: 10),
                          LocationView(
                            address: controller.state.selectedAddress.value,
                            onSelect: (address) => controller.updateAddress(address),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisExtent: 150,
                          mainAxisSpacing: 8
                        ),
                        shrinkWrap: true,
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          ButtonView category = controller.categories[index];

                          return Obx(() {
                            bool selected = controller.state.selectedCategory.value == category.path;

                            return ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Material(
                                color: selected ? Theme.of(context).primaryColor : Theme.of(context).appBarTheme.backgroundColor,
                                child: InkWell(
                                  onTap: () => controller.selectCategory(category.path),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      children: [
                                        Expanded(child: CategoryImage(image: category.asset, height: 50, width: 80)),
                                        const SizedBox(height: 4),
                                        SText.center(
                                          text: category.header,
                                          size: 9,
                                          color: selected ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).primaryColor
                                        )
                                      ],
                                    )
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            controller.banner()
          ],
        )
      );
    });
  }
}
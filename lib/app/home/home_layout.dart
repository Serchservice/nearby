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
        floaterPosition: 10,
        floater: controller.category() != null ? Swiper(
          onRightSwipe: (d) => controller.clearSelection(),
          child: Container(
            margin: EdgeInsets.all(Sizing.space(8)),
            padding: EdgeInsets.all(Sizing.space(6)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SText(
                  text: "Selected category (Swipe right to dismiss)",
                  size: Sizing.font(12),
                  color: Theme.of(context).primaryColorLight
                ),
                SText(
                  text: controller.category()!.title,
                  size: Sizing.font(12),
                  color: Theme.of(context).scaffoldBackgroundColor
                ),
                SText(
                  text: controller.state.category.value.title,
                  size: Sizing.font(10),
                  color: Theme.of(context).scaffoldBackgroundColor
                ),
              ],
            ),
          ),
        ) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: Sizing.space(12)),
              color: Theme.of(context).appBarTheme.backgroundColor,
              width: MediaQuery.sizeOf(context).width,
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
                  SText(
                    text: CommonUtility.greeting(),
                    size: Sizing.font(20),
                    weight: FontWeight.w700,
                    color: Theme.of(context).primaryColor
                  ),
                  const SizedBox(height: 10),
                  SText(
                    text: "Your Location (Tap to update)",
                    size: Sizing.font(12),
                    color: Theme.of(context).primaryColorLight
                  ),
                  LocationView(
                    address: controller.state.selectedAddress.value,
                    isSearching: controller.state.isSearchingLocation.value,
                    onSearch: () => AppInformationSheet.open(
                      options: controller.options,
                      onTap: (view) => controller.onLocationSearch(view)
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(child: SizedBox(width: 20)),
                      Material(
                        color: controller.canShowButton ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.surface,
                        child: InkWell(
                          onTap: controller.canShowButton ? () => controller.search() : null,
                          child: Padding(
                            padding: EdgeInsets.all(Sizing.space(9)),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: Sizing.space(24),
                              color: Theme.of(context).scaffoldBackgroundColor
                            )
                          )
                        )
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: Category.categories.map((category) {
                      bool selected = category.sections.any((cat) {
                        return cat.type == controller.state.category.value.type;
                      });

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selected ? Theme.of(context).primaryColor : CommonColors.hint,
                              width: selected ? 2 : 1
                            )
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => CategorySectionSheet.open(
                                  category: category,
                                  selected: controller.state.category.value,
                                  onTap: controller.selectSection
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SText(
                                        text: category.title,
                                        size: 14,
                                        color: Theme.of(context).primaryColor
                                      ),
                                      Spacer(),
                                      Image.asset(carDriveReverseImage, width: 60),
                                    ],
                                  )
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            if(controller.bannerAdManager.banner() != null) ...[
              controller.bannerAdManager.banner()!
            ]
          ],
        )
      );
    });
  }
}
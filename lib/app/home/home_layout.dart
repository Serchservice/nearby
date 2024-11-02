import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:get/get.dart';

class HomeLayout extends GetResponsiveView<HomeController> {
  static String get route => "/";

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      endDrawer: AppDrawer(),
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
                Obx(() => LocationView(
                  address: controller.state.selectedAddress.value,
                  isSearching: controller.state.isSearchingLocation.value,
                  onSearch: () => AppInformationSheet.open(
                    options: controller.options,
                    onTap: (view) => controller.onLocationSearch(view)
                  ),
                )),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(child: SizedBox(width: 20)),
                    Obx(() => Material(
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
                    ))
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: LiquidPullToRefresh(
              onRefresh: () => controller.refreshCategories(),
              color: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).colorScheme.surface,
              showChildOpacityTransition: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildCategories(context)
                  ],
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
  }

  Widget _buildCategories(BuildContext context) {
    SliverGridDelegateWithFixedCrossAxisCount count = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisExtent: 150,
      mainAxisSpacing: 8
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() {
        if(controller.state.isFetchingCategories.value) {
          return LoadingShimmer(
            content: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: count,
              shrinkWrap: true,
              itemCount: 8,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: CommonColors.shimmerHigh
                  ),
                );
              },
            ),
          );
        } else {
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: count,
            shrinkWrap: true,
            itemCount: controller.state.categories.length,
            itemBuilder: (context, index) {
              DriveCategoryResponse category = controller.state.categories[index];

              return Obx(() {
                bool selected = controller.state.selectedCategory.value == category.name;

                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Material(
                    color: selected ? Theme.of(context).primaryColor : Theme.of(context).appBarTheme.backgroundColor,
                    child: InkWell(
                      onTap: () => controller.selectCategory(category.name),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Expanded(child: CategoryImage(image: category.image, height: 50, width: 80)),
                            const SizedBox(height: 4),
                            SText.center(
                              text: category.type,
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
          );
        }
      }),
    );
  }
}
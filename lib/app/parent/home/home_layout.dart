import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeLayout extends GetResponsiveView<ParentController> {
  static String get route => "/";

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    List<FakeField> fields = [
      FakeField(
        onTap: () => Navigate.to(LocationSearchLayout.route),
        searchText: "Where is your starting point?",
        buttonText: "Search"
      ),
      FakeField(
        onTap: () => Navigate.to(CategorySearchLayout.route),
        searchText: "What nearby place are you looking for?",
        showSearch: false,
        buttonText: "Around"
      )
    ];

    List<HomeItem> items = [
      HomeItem(title: "Suggestions", sections: Category.suggestions),
      HomeItem(title: "Emergencies", sections: Category.emergencies),
      HomeItem(title: "Services", sections: Category.services),
    ];

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
                  Assets.logoSplashWhite,
                  width: 120,
                  height: 80,
                  fit: BoxFit.cover,
                  color: Theme.of(context).primaryColor
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...fields.map((item) {
                      return SearchStep(
                        custom: item,
                        height: 30,
                        showBottom: fields.length - 1 != fields.indexOf(item),
                      );
                    }),
                    controller.selection(context),
                    ...items.map((item) {
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
                            height: 170,
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

                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Material(
                                    color: Theme.of(context).appBarTheme.backgroundColor,
                                    child: InkWell(
                                      onTap: () => controller.handleQuickOption(section),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 120,
                                            width: MediaQuery.sizeOf(context).width,
                                            alignment: Alignment.bottomLeft,
                                            padding: EdgeInsets.only(top: 24, bottom: 24, left: 8),
                                            decoration: BoxDecoration(gradient: LinearGradient(colors: section.colors)),
                                            child: Image(
                                              image: AssetUtility.image(Assets.commonDriveWhite),
                                              height: 30,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: SText(
                                                    text: "Nearby ${section.description.toLowerCase()} around me",
                                                    size: Sizing.font(14),
                                                    color: Theme.of(context).primaryColor,
                                                    weight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Icon(
                                                  Icons.arrow_right_alt_rounded,
                                                  size: Sizing.space(24),
                                                  color: Theme.of(context).primaryColorLight
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
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
          ),
          controller.bannerAdManager.banner(),
        ],
      )
    );
  }
}

class HomeItem {
  final String title;
  final List<CategorySection> sections;

  HomeItem({required this.title, required this.sections});
}
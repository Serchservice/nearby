import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

import 'widgets/category_section_box.dart';

class ServicesLayout extends GetResponsiveView<ServicesController> {
  static String get route => "/";

  ServicesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      layoutKey: Key("Services"),
      child: BannerAdLayout(
        child: Obx(() {
          ParentController parent = ParentController.data;
          bool showAds = parent.state.showAds.value;
          List<Suggestion> suggestions = controller.suggestions;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: PullToRefresh(
              onRefreshed: controller.getPromotionalItem,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextBuilder(
                          text: "Services",
                          size: Sizing.font(30),
                          weight: FontWeight.bold,
                          color: Theme.of(context).primaryColor
                        ),
                      ),
                      InfoButton(
                        defaultIcon: Icons.view_carousel_rounded,
                        tip: "Nearby History",
                        padding: WidgetStatePropertyAll(EdgeInsets.zero),
                        backgroundColor: WidgetStatePropertyAll(CommonColors.instance.darkTheme2.lighten(73)),
                        defaultIconColor: CommonColors.instance.darkTheme2,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: WidgetStatePropertyAll(Size(30, 30)),
                        onPressed: NearbyHistoryLayout.to,
                      )
                    ],
                  ),
                  if(parent.hasDetails) ...[
                    NearbyPlaceSearchSelection(
                      hasDetails: parent.hasDetails,
                      onCleared: parent.clearSelection,
                      onSearch: parent.search,
                      canShowButton: parent.canShowButton,
                      title: parent.state.category.value.title,
                      category: parent.category,
                      address: parent.state.selectedAddress.value,
                      showClearButton: true
                    )
                  ],
                  Expanded(
                    child: ListView.separated(
                      itemCount: suggestions.length,
                      separatorBuilder: (BuildContext context, int index) {
                        if(showAds) {
                          return Column(
                            spacing: 18,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BannerAdWidget(height: 250, margin: EdgeInsets.only(top: 20)),
                              Spacing.vertical(2)
                            ],
                          );
                        } else {
                          return Spacing.vertical(20);
                        }
                      },
                      itemBuilder: (BuildContext context, int index) {
                        Suggestion suggestion = suggestions[index];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextBuilder(
                              text: suggestion.title,
                              size: Sizing.font(20),
                              color: Theme.of(context).primaryColor,
                              weight: FontWeight.bold,
                            ),
                            Spacing.vertical(10),
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
                                itemCount: suggestion.sections.length,
                                itemBuilder: (context, index) {
                                  CategorySection section = suggestion.sections[index];

                                  return CategorySectionBox(
                                    section: section,
                                    onClicked: parent.handleQuickOption
                                  );
                                },
                              ),
                            )
                          ],
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
          );
        })
      )
    );
  }
}
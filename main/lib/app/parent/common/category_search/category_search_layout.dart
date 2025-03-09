import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

import 'controllers/category_search_controller.dart';

class CategorySearchLayout extends GetResponsiveView<CategorySearchController> {
  static final String route = "/search/category";

  static Future<T?>? to<T>({CategorySection? section}) {
    return Navigate.to(route, arguments: section);
  }

  CategorySearchLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      layoutKey: Key("Category Search"),
      appbar: AppBar(
        title: TextBuilder.center(
          text: "Category Search",
          size: Sizing.font(16),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            padding: EdgeInsets.all(Sizing.space(16)),
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Field(
                  padding: const EdgeInsets.all(8),
                  hint: "Search for a keyword or name",
                  controller: controller.searchController,
                ),
              ],
            ),
          ),
          BannerAdLayout(
            isExpanded: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                if(controller.state.filtered.isNotEmpty) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisExtent: 130,
                      mainAxisSpacing: 4
                    ),
                    shrinkWrap: true,
                    itemCount: controller.state.filtered.length,
                    itemBuilder: (context, index) {
                      CategorySection section = controller.state.filtered[index];

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Material(
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          child: InkWell(
                            onTap: () => controller.handleSelect(section),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Expanded(child: CategoryImage(image: carDriveImage, height: 50, width: 80)),
                                  Spacing.vertical(4),
                                  TextBuilder.center(
                                    text: section.title,
                                    size: 14,
                                    color: Theme.of(context).primaryColor,
                                    flow: TextOverflow.ellipsis,
                                  )
                                ],
                              )
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if(controller.searchController.text.isNotEmpty && controller.state.filtered.isEmpty) {
                  return Center(
                    child: TextBuilder(
                      text: "No result from your keyword search",
                      size: Sizing.font(16),
                      color: Theme.of(context).primaryColor,
                    )
                  );
                } else {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisExtent: 130,
                      mainAxisSpacing: 4
                    ),
                    shrinkWrap: true,
                    itemCount: Category.categories.length,
                    itemBuilder: (context, index) {
                      Category category = Category.categories[index];

                      return Obx(() {
                        CategorySection section = controller.state.selected.value;

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Material(
                            color: Theme.of(context).appBarTheme.backgroundColor,
                            child: InkWell(
                              onTap: () => CategorySectionSheet.open(
                                category: category,
                                selected: section,
                                onTap: controller.handleSelect
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    Expanded(child: CategoryImage(image: carDriveReverseImage, height: 50, width: 80)),
                                    Spacing.vertical(4),
                                    TextBuilder.center(
                                      text: category.title,
                                      size: 14,
                                      color: Theme.of(context).primaryColor,
                                      flow: TextOverflow.ellipsis,
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
            ),
          ),
        ],
      )
    );
  }
}
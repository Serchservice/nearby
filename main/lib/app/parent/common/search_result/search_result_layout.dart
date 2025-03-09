import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide GetStringUtils;
import 'package:smart/smart.dart';

import 'controllers/search_result_controller.dart';
import 'widgets/search_result_filter_sheet.dart';

class ResultLayout extends GetResponsiveView<ResultController> {
  static String get route => "/search";

  ResultLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      layoutKey: Key("Result"),
      appbar: AppBar(
        elevation: 0.5,
        title: Obx(() => TextBuilder.center(
          text: controller.state.title.value,
          size: Sizing.font(16),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        )),
        actions: [
          IconButton(
            onPressed: () => ResultFilterSheet.open(
              list: controller.driveFilters,
              selectedIndex: controller.state.filter.value,
              onUpdate: controller.updateSearch,
              radius: controller.state.radius.value
            ),
            icon: Icon(
              Icons.filter_list_rounded,
              color: Theme.of(context).primaryColor
            )
          )
        ]
      ),
      child: BannerAdLayout(
        child: Obx(() {
          String message = controller.noResult();
          String category = controller.state.search.value.category.type;

          return PullToRefresh(
            onRefreshed: () => controller.shopController.refresh(),
            child: PagedListView<int, SearchShopResponse>.builder(
              controller: controller.shopController,
              builderDelegate: PagedChildBuilderDelegate<SearchShopResponse>(
                itemBuilder: (context, metadata) {
                  return ShopSearchItem(
                    shop: metadata.item,
                    pickup: controller.state.search.value.pickup,
                    title: category.replaceAll("_", " ").capitalizeEach,
                  );
                },
                firstPageErrorIndicatorBuilder: (context) => PagingFirstPageErrorIndicator(
                  error: controller.shopController.error,
                  onTryAgain: () => controller.shopController.refresh()
                ),
                firstPageProgressIndicatorBuilder: (_) => PagingFirstPageLoadingIndicator(height: 90,),
                noItemsFoundIndicatorBuilder: (context) => PagingNoItemFoundIndicator(
                  message: message,
                  icon: Icons.manage_search,
                  onRefresh: controller.shopController.refresh
                ),
                // noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
                // newPageProgressIndicatorBuilder: (_) => NewPageProgressIndicator(),
                // newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
                //   error: controller.shopController.error,
                //   onTryAgain: () => controller.shopController.retryLastFailedRequest(),
                // ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
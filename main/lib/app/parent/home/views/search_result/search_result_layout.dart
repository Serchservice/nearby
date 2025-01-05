import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ResultLayout extends GetResponsiveView<ResultController> {
  static String get route => "/result";

  ResultLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      layoutKey: Key("Result"),
      appbar: AppBar(
        elevation: 0.5,
        title: Obx(() => SText.center(
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
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              String message = controller.noResult();
              String category = controller.state.search.value.category.type;

              return PullToRefresh(
                onRefreshed: () => controller.shopController.refresh(),
                child: PagedListView<int, SearchShopResponse>(
                  pagingController: controller.shopController,
                  builderDelegate: PagedChildBuilderDelegate<SearchShopResponse>(
                    itemBuilder: (context, shop, index) {
                      return SearchResultItem(
                        shop: shop,
                        pickup: controller.state.search.value.pickup,
                        title: CommonUtility.capitalizeWords(category.replaceAll("_", " ")),
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
          BannerAdWidget(),
        ],
      )
    );
  }
}
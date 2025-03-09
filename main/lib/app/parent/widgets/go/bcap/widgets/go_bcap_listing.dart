import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class GoBCapListing extends StatelessWidget {
  final PagedController<int, GoBCap> controller;
  final String id;
  final bool useGrid;
  final bool showAds;

  const GoBCapListing({
    super.key,
    required this.controller,
    this.id = "",
    this.useGrid = false,
    required this.showAds
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveUtil responsive = ResponsiveUtil(context);
    double? cardHeight = useGrid ? 300 : null;

    Widget noItem = PagingNoItemFoundIndicator(
      message: "No bcaps found",
      icon: Icons.perm_media_rounded,
      onRefresh: controller.refresh
    );

    Widget item(ItemMetadata<GoBCap> meta, double? width) => GoBCapCard(
      cap: meta.item,
      id: id,
      height: cardHeight,
      width: width,
      isClickable: useGrid
    );

    SliverGridDelegate gridDelegate(int count, double width) => SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: count,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      childAspectRatio: width,
      mainAxisExtent: cardHeight
    );

    if(useGrid) {
      int count = 2;
      double width = responsive.screenWidth / count;

      return PagedGridView<int, GoBCap>.separated(
        controller: controller,
        gridDelegate: gridDelegate(count, width),
        separatorStrategy: (int index) => (index + 3) % 4 == 0,
        separatorBuilder: (context, index) {
          if(showAds) {
            return BannerAdWidget(height: cardHeight);
          }

          return null;
        },
        builderDelegate: PagedChildBuilderDelegate<GoBCap>(
          firstPageErrorIndicatorBuilder: (BuildContext context) => PagingFirstPageErrorIndicator(
            error: controller.error,
            onTryAgain: () => controller.refresh()
          ),
          firstPageProgressIndicatorBuilder: (BuildContext _) => GridView.builder(
            itemCount: 12,
            gridDelegate: gridDelegate(count, width),
            itemBuilder: (BuildContext context, int index) => GoBCapCardLoading(height: cardHeight),
          ),
          noItemsFoundIndicatorBuilder: (BuildContext context) => noItem,
          itemBuilder: (BuildContext context, ItemMetadata<GoBCap> metadata) => item(metadata, width),
        ),
      );
    } else {
      return PagedPageView<int, GoBCap>.separated(
        controller: controller,
        separatorBuilder: (BuildContext context, int index) {
          if(showAds) {
            return BannerAdWidget(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width
            );
          }

          return null;
        },
        builderDelegate: PagedChildBuilderDelegate<GoBCap>(
          firstPageErrorIndicatorBuilder: (BuildContext context) => PagingFirstPageErrorIndicator(
            error: controller.error,
            onTryAgain: () => controller.refresh()
          ),
          firstPageProgressIndicatorBuilder: (BuildContext _) => GoBCapCardLoading(),
          noItemsFoundIndicatorBuilder: (BuildContext context) => noItem,
          itemBuilder: (BuildContext context, ItemMetadata<GoBCap> metadata) => item(metadata, null),
        ),
      );
    }
  }
}
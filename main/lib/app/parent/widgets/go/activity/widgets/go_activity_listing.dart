import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class GoActivityListing extends StatelessWidget {
  final PagedController<int, GoActivity> controller;
  final String id;
  final bool applyPadding;
  final double? height;
  final MainAxisAlignment? dotAlignment;
  final bool isClickable;
  final bool showAds;

  const GoActivityListing({
    super.key,
    required this.controller,
    this.id = "",
    this.applyPadding = true,
    this.height,
    this.dotAlignment,
    this.isClickable = true,
    required this.showAds
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveUtil responsive = ResponsiveUtil(context);

    Widget noItem = PagingNoItemFoundIndicator(
      message: "No activities found",
      icon: Icons.attractions_rounded,
      onRefresh: controller.refresh
    );

    Widget item(ItemMetadata<GoActivity> meta) => GoActivityCard(
      activity: meta.item,
      id: id,
      applyPadding: applyPadding,
      height: height,
      dotAlignment: dotAlignment,
      isClickable: isClickable
    );

    double cardHeight = 380;
    SliverGridDelegate gridDelegate(int count, double width) => SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: count,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      childAspectRatio: width,
      mainAxisExtent: cardHeight
    );

    if(responsive.isDesktop) {
      int count = 3;
      double width = responsive.screenWidth / 3;

      return PagedGridView<int, GoActivity>.separated(
        controller: controller,
        gridDelegate: gridDelegate(count, width),
        separatorBuilder: (context, index) {
          if(showAds) {
            return BannerAdWidget(height: cardHeight);
          }

          return null;
        },
        builderDelegate: PagedChildBuilderDelegate<GoActivity>(
          firstPageErrorIndicatorBuilder: (context) => PagingFirstPageErrorIndicator(
            error: controller.error,
            onTryAgain: () => controller.refresh()
          ),
          firstPageProgressIndicatorBuilder: (_) => GridView.builder(
            gridDelegate: gridDelegate(count, width),
            itemBuilder: (context, index) => GoActivityCardLoading(width: width),
          ),
          noItemsFoundIndicatorBuilder: (context) => noItem,
          itemBuilder: (BuildContext context, ItemMetadata<GoActivity> metadata) => item(metadata),
        ),
      );
    } else {
      return PagedListView<int, GoActivity>.separated(
        controller: controller,
        spacing: Spacing.vertical(10),
        separatorStrategy: (int index) => (index + 1) % 2 == 0,
        separatorBuilder: (context, index) {
          if(showAds) {
            return BannerAdWidget(height: 250);
          } else {
            return Spacing.vertical(10);
          }
        },
        builderDelegate: PagedChildBuilderDelegate<GoActivity>(
          firstPageErrorIndicatorBuilder: (context) => PagingFirstPageErrorIndicator(
            error: controller.error,
            onTryAgain: () => controller.refresh()
          ),
          firstPageProgressIndicatorBuilder: (_) => SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: (6).listGenerator.map((_) => GoActivityCardLoading()).toList(),
            )
          ),
          noItemsFoundIndicatorBuilder: (context) => noItem,
          itemBuilder: (BuildContext context, ItemMetadata<GoActivity> metadata) => item(metadata),
        ),
      );
    }
  }
}
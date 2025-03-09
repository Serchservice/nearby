import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class GoActivityRatingSheetListView extends StatelessWidget {
  final PagedController<int, GoActivityRating> controller;

  const GoActivityRatingSheetListView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    Widget loading = Row(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: CommonColors.instance.shimmerHigh,
          )
        ),
        Expanded(
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: 18,
            decoration: BoxDecoration(
              color: CommonColors.instance.shimmerHigh,
              borderRadius: BorderRadius.circular(12)
            )
          )
        ),
        Container(
          width: 60,
          height: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: CommonColors.instance.shimmerHigh,
          )
        ),
      ]
    );

    Widget item(ItemMetadata<GoActivityRating> meta) {
      GoActivityRating rating = meta.item;
      Color color = rating.isCurrentUser ? CommonColors.instance.lightTheme : Theme.of(context).primaryColor;

      return Container(
        padding: rating.isCurrentUser ? EdgeInsets.all(4) : null,
        decoration: BoxDecoration(
          color: rating.isCurrentUser ? CommonColors.instance.bluish.lighten(5) : null,
          borderRadius: rating.isCurrentUser ? BorderRadius.circular(16) : null
        ),
        child: Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Avatar(radius: 12, avatar: rating.avatar),
            Expanded(
              child: TextBuilder(
                text: rating.name,
                color: color,
                size: Sizing.font(14),
              )
            ),
            RatingIcon(
              rating: rating.rating,
              color: color,
              config: RatingIconConfig()
            )
          ]
        ),
      );
    }

    return PagedListView<int, GoActivityRating>.builder(
      controller: controller,
      builderDelegate: PagedChildBuilderDelegate<GoActivityRating>(
        firstPageErrorIndicatorBuilder: (context) => PagingFirstPageErrorIndicator(
          error: controller.error,
          onTryAgain: () => controller.refresh()
        ),
        firstPageProgressIndicatorBuilder: (_) => PagingFirstPageLoadingIndicator.custom(
          custom: loading,
          spacing: 15,
        ),
        noItemsFoundIndicatorBuilder: (context) => PagingNoItemFoundIndicator(
          message: "No ratings found",
          icon: Icons.rate_review_rounded,
          onRefresh: controller.refresh
        ),
        itemBuilder: (BuildContext context, ItemMetadata<GoActivityRating> metadata) => item(metadata),
      ),
    );
  }
}

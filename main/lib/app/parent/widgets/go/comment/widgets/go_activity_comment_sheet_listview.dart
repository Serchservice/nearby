import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class GoActivityCommentSheetListView extends StatelessWidget {
  final PagedController<int, GoActivityComment> controller;

  const GoActivityCommentSheetListView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    Widget loading = Column(
      spacing: 4,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            )
          ]
        ),
        Container(
          width: MediaQuery.sizeOf(context).width,
          height: 60,
          decoration: BoxDecoration(
            color: CommonColors.instance.shimmerHigh,
            borderRadius: BorderRadius.circular(12)
          )
        )
      ]
    );

    Widget item(ItemMetadata<GoActivityComment> meta) {
      GoActivityComment comment = meta.item;
      Color color = comment.isCurrentUser ? CommonColors.instance.lightTheme : Theme.of(context).primaryColor;

      return Container(
        padding: comment.isCurrentUser ? EdgeInsets.all(4) : null,
        decoration: BoxDecoration(
          color: comment.isCurrentUser ? CommonColors.instance.bluish.lighten(5) : null,
          borderRadius: comment.isCurrentUser ? BorderRadius.circular(16) : null
        ),
        child: Column(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Avatar(radius: 12, avatar: comment.avatar),
                Expanded(
                  child: TextBuilder(
                    text: comment.name,
                    color: color,
                    size: Sizing.font(14),
                  )
                )
              ]
            ),
            TextBuilder(text: comment.comment, color: color, size: Sizing.font(14))
          ]
        ),
      );
    }

    return PagedListView<int, GoActivityComment>.builder(
      controller: controller,
      builderDelegate: PagedChildBuilderDelegate<GoActivityComment>(
        firstPageErrorIndicatorBuilder: (context) => PagingFirstPageErrorIndicator(
          error: controller.error,
          onTryAgain: () => controller.refresh()
        ),
        firstPageProgressIndicatorBuilder: (_) => PagingFirstPageLoadingIndicator.custom(
          custom: loading,
          spacing: 15,
        ),
        noItemsFoundIndicatorBuilder: (context) => PagingNoItemFoundIndicator(
          message: "No comments found",
          icon: Icons.comment_bank_rounded,
          onRefresh: controller.refresh
        ),
        itemBuilder: (BuildContext context, ItemMetadata<GoActivityComment> metadata) => item(metadata),
      ),
    );
  }
}

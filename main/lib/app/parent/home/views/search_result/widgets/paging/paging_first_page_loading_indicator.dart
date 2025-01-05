import 'package:drive/library.dart';
import 'package:flutter/material.dart';

class PagingFirstPageLoadingIndicator extends StatelessWidget {
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final int? count;
  final double spacing;

  const PagingFirstPageLoadingIndicator({
    super.key,
    this.height,
    this.padding,
    this.borderRadius,
    this.count,
    this.margin,
    this.spacing = 4
  });

  @override
  Widget build(BuildContext context) {
    return LoadingShimmer(
      content: Column(
        spacing: spacing,
        children: CommonUtility.generateList(count ?? 6).map((_) => Container(
          width: MediaQuery.sizeOf(context).width,
          height: height ?? 60,
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            color: CommonColors.shimmerHigh,
            borderRadius: borderRadius
          ),
        )).toList(),
      )
    );
  }
}

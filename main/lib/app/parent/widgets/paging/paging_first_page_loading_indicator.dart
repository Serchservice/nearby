import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class PagingFirstPageLoadingIndicator extends StatelessWidget {
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final int? count;
  final double spacing;
  final bool _isGrid;
  final double width;
  final Widget? custom;

  const PagingFirstPageLoadingIndicator({
    super.key,
    this.height,
    this.padding,
    this.borderRadius,
    this.count,
    this.margin,
    this.spacing = 4,
  }) : _isGrid = false, width = 0, custom = null;

  const PagingFirstPageLoadingIndicator.grid({
    super.key,
    this.height,
    this.padding,
    this.borderRadius,
    this.count,
    this.margin,
    this.spacing = 4,
    required this.width,
  }) : _isGrid = true, custom = null;

  const PagingFirstPageLoadingIndicator.custom({
    super.key,
    required this.custom,
    this.spacing = 4,
  }) : _isGrid = false, width = 0, height = null,
        padding = null, borderRadius = null, count = null, margin = null;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LoadingShimmer(
        isDarkMode: Database.instance.isDarkTheme,
        darkHighlightColor: CommonColors.instance.shimmerHigh.darken(66),
        darkBaseColor: CommonColors.instance.shimmerHigh.darken(65),
        content: _build(context)
      ),
    );
  }

  Widget _build(BuildContext context) {
    if(_isGrid) {
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: (count ?? 6).listGenerator.map((_) => custom ?? Container(
          width: width,
          height: height ?? 60,
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            color: CommonColors.instance.shimmerHigh,
            borderRadius: borderRadius
          ),
        )).toList(),
      );
    } else {
      return Column(
        spacing: spacing,
        children: (count ?? 6).listGenerator.map((_) => custom ?? Container(
          width: MediaQuery.sizeOf(context).width,
          height: height ?? 60,
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
              color: CommonColors.instance.shimmerHigh,
              borderRadius: borderRadius
          ),
        )).toList(),
      );
    }
  }
}

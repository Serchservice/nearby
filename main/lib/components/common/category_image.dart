import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class CategoryImage extends StatelessWidget {
  final double? height;
  final double? width;
  final String image;
  const CategoryImage({super.key, this.height, this.width, required this.image});

  @override
  Widget build(BuildContext context) {
    double w = width ?? 120;
    double h = height ?? 123;
    return Image(
      image: AssetUtility.image(image),
      width: w,
      height: h,
      errorBuilder: (context, obj, trace) {
        return Image.asset(
          Database.instance.isDarkTheme ? Assets.commonDriveWhite : Assets.commonDriveBlack,
          width: w,
          height: h,
        );
      },
    );
  }
}
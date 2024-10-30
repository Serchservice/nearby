import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class RatingIcon extends StatelessWidget {
  const RatingIcon({
    super.key,
    required this.rating,
    this.color, this.iconSize, this.textSize
  });

  final double rating;
  final double? iconSize;
  final double? textSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          rating == 5
            ? Icons.star_rounded
            : rating > 0.9
            ? Icons.star_half_rounded
            : Icons.star_border_rounded,
          color: color ?? Theme.of(context).primaryColor,
          size: iconSize ?? 18,
        ),
        SText(
          text: "$rating",
          color: color ?? Theme.of(context).primaryColor,
          size: Sizing.font(textSize ?? 14),
          weight: FontWeight.bold
        ),
      ],
    );
  }
}
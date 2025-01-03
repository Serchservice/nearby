import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class SearchResultItem extends StatelessWidget {
  final SearchShopResponse shop;
  final String title;
  final Address pickup;

  const SearchResultItem({super.key, required this.shop, required this.pickup, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: CommonUtility.lightenColor(Theme.of(context).colorScheme.surface, 6),
          child: InkWell(
            onTap: () => SearchResultItemSheet.open(pickup: pickup, shop: shop, category: title),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContent(
                    context: context,
                    image: shop.shop.logo,
                    name: shop.shop.name,
                    distance: shop.distanceInKm,
                    rating: shop.shop.rating,
                    category: shop.shop.category
                  ),
                  _buildRecommended(context),
                ],
              ),
            )
          )
        ),
      ),
    );
  }

  Widget _buildRecommended(BuildContext context) {
    if(!shop.isGoogle) {
      return Container(
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.only(left: 6, top: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CommonColors.success)
        ),
        child: SText(text: "RECOMMENDED", size: Sizing.font(12), color: CommonColors.success),
      );
    }

    return SizedBox.shrink();
  }

  Widget _buildContent({
    required BuildContext context,
    required String image,
    required String name,
    required String distance,
    required double rating,
    required String category
  }) {
    Color textColor = Theme.of(context).primaryColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Avatar.small(avatar: image),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SText(
                      text: CommonUtility.capitalizeWords(name),
                      size: Sizing.font(14),
                      color: textColor,
                      weight: FontWeight.bold,
                      flow: TextOverflow.ellipsis
                    ),
                  ),
                  const SizedBox(width: 10),
                  SText(text: distance, size: Sizing.font(12), color: textColor),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: SText(
                      text: CommonUtility.capitalizeWords(category),
                      size: Sizing.font(11),
                      color: Theme.of(context).primaryColorLight,
                      flow: TextOverflow.ellipsis
                    ),
                  ),
                  const SizedBox(width: 10),
                  RatingIcon(
                    rating: rating,
                    iconSize: 14,
                    textSize: 10
                  ),
                ],
              ),
            ],
          )
        ),
      ],
    );
  }
}
import 'package:drive/library.dart';
import 'package:flutter/material.dart';

class HomeCurrentLocation extends StatelessWidget {
  final bool isLoading;
  final Address address;

  const HomeCurrentLocation({super.key, required this.isLoading, required this.address});

  @override
  Widget build(BuildContext context) {
    if(!isLoading && !address.hasAddress) {
      return SizedBox.shrink();
    }

    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SText(
          text: "Your current location",
          size: Sizing.font(12),
          color: Theme.of(context).primaryColorLight,
        ),
        if(isLoading) ...[
          LoadingShimmer(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 24,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: CommonColors.shimmerHigh
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 12,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: CommonColors.shimmerHigh
                  ),
                )
              ],
            )
          ),
        ] else ...[
          SText(
            text: address.place,
            size: Sizing.font(14),
            color: Theme.of(context).primaryColor,
            lines: 2,
            flow: TextOverflow.ellipsis
          ),
          if(address.country.isNotEmpty) ...[
            SText(
              text: address.country,
              size: Sizing.font(12),
              color: Theme.of(context).primaryColorLight
            ),
          ]
        ]
      ],
    );
  }
}
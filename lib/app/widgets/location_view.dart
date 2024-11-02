import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class LocationView extends StatelessWidget {
  final Address address;
  final Function(Address)? onSelect;
  final VoidCallback? onShowOptions;
  final VoidCallback? onSearch;
  final bool withPadding;
  final double fontSize;
  final bool isSearching;

  const LocationView({
    super.key,
    required this.address,
    this.onSelect,
    this.withPadding = false,
    this.fontSize = 12,
    this.onShowOptions,
    this.onSearch,
    this.isSearching = false
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onShowOptions ?? onSearch ?? () => onSelect?.call(address),
        child: Padding(
          padding: withPadding ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(!isSearching) ...[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SText(
                        text: address.place.isNotEmpty
                          ? address.place
                          : onShowOptions != null
                            ? "Tap to search your location"
                            : "Tap to use current location",
                        size: Sizing.font(fontSize),
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
                    ],
                  )
                )
              ] else ...[
                Expanded(
                  child: LoadingShimmer(
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
                ),
              ],
              Image(
                image: AssetUtility.image(Assets.mapLocation),
                width: 60,
                height: 60
              )
            ],
          ),
        ),
      ),
    );
  }
}
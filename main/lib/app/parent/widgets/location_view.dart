import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

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
        onTap: onShowOptions ?? onSearch ?? (onSelect.isNotNull ? () => onSelect!(address) : null),
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
                      TextBuilder(
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
                        TextBuilder(
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
                    isDarkMode: Database.instance.isDarkTheme,
                    darkHighlightColor: CommonColors.instance.shimmerHigh.darken(66),
                    darkBaseColor: CommonColors.instance.shimmerHigh.darken(65),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: CommonColors.instance.shimmerHigh
                          ),
                        ),
                        Spacing.vertical(6),
                        Container(
                          height: 12,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: CommonColors.instance.shimmerHigh
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
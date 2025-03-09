import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class NearbyPlaceSearchSelection extends StatelessWidget {
  final bool hasDetails;
  final VoidCallback onCleared;
  final VoidCallback onSearch;
  final bool canShowButton;
  final Category? category;
  final Address? address;
  final String title;
  final bool showClearButton;

  const NearbyPlaceSearchSelection({
    super.key,
    required this.hasDetails,
    required this.onCleared,
    required this.onSearch,
    required this.canShowButton,
    this.category,
    this.address,
    required this.title,
    this.showClearButton = false
  });

  @override
  Widget build(BuildContext context) {
    if(hasDetails) {
      double spacing = 6;

      return Column(
        children: [
          Swiper(
            onRightSwipe: (d) => onCleared(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(spacing * 2),
              child: Material(
                color: Theme.of(context).appBarTheme.backgroundColor,
                child: InkWell(
                  onTap: onSearch,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(address.isNotNull) ...[
                        Padding(
                          padding: EdgeInsets.all(Sizing.space(spacing)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextBuilder(
                                text: "Your Location",
                                size: Sizing.font(12),
                                color: CommonColors.instance.hint
                              ),
                              LocationView(address: address!),
                            ],
                          ),
                        ),
                      ],
                      if(hasDetails) ...[
                        DashedDivider(color: Theme.of(context).primaryColorLight)
                      ],
                      if(category.isNotNull) ...[
                        Padding(
                          padding: EdgeInsets.all(Sizing.space(spacing)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextBuilder(
                                text: "Selected category",
                                size: Sizing.font(12),
                                color: CommonColors.instance.hint
                              ),
                              TextBuilder(
                                text: category!.title,
                                size: Sizing.font(14),
                                color: Theme.of(context).primaryColor
                              ),
                              TextBuilder(
                                text: title,
                                size: Sizing.font(12),
                                color: Theme.of(context).primaryColor
                              ),
                            ],
                          ),
                        ),
                        DashedDivider(color: Theme.of(context).primaryColorLight),
                      ],
                      Padding(
                        padding: EdgeInsets.all(spacing),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if(showClearButton) ...[
                              TextButton(
                                onPressed: onCleared,
                                style: ButtonStyle(
                                  overlayColor: WidgetStatePropertyAll(CommonColors.instance.bluish.lighten(48)),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                                  padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 6))
                                ),
                                child: TextBuilder(
                                  text: "Clear",
                                  color: CommonColors.instance.bluish
                                )
                              )
                            ] else ...[
                              TextBuilder(
                                text: "Note (Swipe right to dismiss ${canShowButton ? "or tap to continue" : ""})",
                                size: Sizing.font(12),
                                color: CommonColors.instance.hint
                              )
                            ],
                            Spacer(),
                            if(canShowButton) ...[
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: Sizing.space(24),
                                color: Theme.of(context).primaryColorLight
                              )
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
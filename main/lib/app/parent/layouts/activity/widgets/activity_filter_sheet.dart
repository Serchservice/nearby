import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class ActivityFilterSheet extends StatelessWidget {
  final List<GoInterest> interests;
  final GoInterest? selected;
  final GoInterestSelected onInterestSelected;

  const ActivityFilterSheet({
    super.key,
    this.selected,
    required this.interests,
    required this.onInterestSelected
  });

  static void open({
    required GoInterestSelected onInterestSelected,
    GoInterest? selected,
    List<GoInterest> interests = const []
  }) {
    Navigate.bottomSheet(
      sheet: ActivityFilterSheet(
        selected: selected,
        onInterestSelected: onInterestSelected,
        interests: interests
      ),
      route: Navigate.appendRoute("/filter"),
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      uiConfig: UiConfig(
        systemNavigationBarColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      child: SingleChildScrollView(
        child: BannerAdLayout(
          mainAxisSize: MainAxisSize.min,
          expandChild: false,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GoBack(),
                  TextBuilder(
                    text: "Filter by your interest",
                    size: Sizing.font(16),
                    weight: FontWeight.bold,
                    color: Theme.of(context).primaryColor
                  ),
                ],
              ),
              if(interests.isNotEmpty) ...[
                Wrap(
                  runAlignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: interests.map((interest) {
                    return InterestViewer(
                      interest: interest,
                      // color: CommonColors.instance.darkTheme2,
                      isSelected: selected.isNotNull && selected!.id.equals(interest.id),
                      onClick: () => onInterestSelected(interest),
                      buttonText: "Filter with ${interest.name}",
                    );
                  }).toList(),
                )
              ] else ...[
                Spacing.vertical(80),
                Center(
                  child: TextBuilder.center(
                    text: "No interests found",
                    size: Sizing.font(18),
                    color: Theme.of(context).primaryColorLight
                  ),
                ),
                Spacing.vertical(80),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

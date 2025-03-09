import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class CreateActivityInterestPicker extends StatelessWidget {
  final List<GoInterestCategory> categories;
  final GoInterest? selected;
  final GoInterestSelected onSelected;

  const CreateActivityInterestPicker({
    super.key,
    required this.categories,
    this.selected,
    required this.onSelected
  });

  static void open({
    required List<GoInterestCategory> categories,
    GoInterest? selected,
    required GoInterestSelected onSelected
  }) {
    Navigate.bottomSheet(
      sheet: CreateActivityInterestPicker(categories: categories, selected: selected, onSelected: onSelected),
      route: Navigate.appendRoute("/pick-interest"),
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: BannerAdLayout(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GoBack(),
            TextBuilder(
              text: "Let us know this activity's interest",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(24),
              weight: FontWeight.bold,
            ),
            TextBuilder(
              text: "Align your activity with others with similar taste.",
              color: Theme.of(context).primaryColor,
              size: Sizing.font(14),
            ),
            Spacing.vertical(10),
            Expanded(
              child: InterestSelector(
                isMultipleAllowed: false,
                categories: categories,
                isScrollable: true,
                buttonText: "Select",
                selected: selected.isNotNull ? [selected!] : [],
                goInterestListener: (interests) {
                  Navigate.close(closeAll: false);
                  onSelected(interests.first);
                },
              ),
            )
          ],
        ),
      )
    );
  }
}
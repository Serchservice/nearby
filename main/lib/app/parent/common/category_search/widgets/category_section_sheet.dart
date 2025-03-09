import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class CategorySectionSheet extends StatelessWidget {
  final Category category;
  final CategorySection selected;
  final Function(CategorySection) onTap;

  const CategorySectionSheet({
    super.key,
    required this.category,
    required this.onTap,
    required this.selected
  });

  static void open({
    required Category category,
    required CategorySection selected,
    required Function(CategorySection) onTap
  }) {
    Navigate.bottomSheet(
      sheet: CategorySectionSheet(category: category, onTap: onTap, selected: selected),
      route: Navigate.appendRoute("/${category.title.toLowerCase()}"),
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      sheetPadding: const EdgeInsets.all(16),
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(Sizing.space(2)),
                width: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(16)
                ),
              ),
            ),
            Spacing.vertical(20),
            Center(
              child: TextBuilder(
                text: category.title,
                color: Theme.of(context).primaryColor,
                size: Sizing.font(18),
                weight: FontWeight.bold,
              ),
            ),
            Spacing.vertical(15),
            Column(
              children: category.sections.map((option) {
                bool isSelected = selected.type.equalsIgnoreCase(option.type);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Material(
                    color: isSelected ? Theme.of(context).textSelectionTheme.selectionColor : Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigate.close(result: option);
                        onTap(option);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(Sizing.space(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(carDriveImage, width: 30),
                            Spacing.horizontal(12),
                            TextBuilder(
                              text: option.title,
                              size: 14,
                              color: Theme.of(context).primaryColor
                            ),
                            if(isSelected) ...[
                              Spacer(),
                              Icon(Icons.playlist_add_check_circle_rounded, color: Theme.of(context).primaryColor)
                            ]
                          ],
                        ),
                      ),
                    ),
                  )
                );
              }).toList(),
            )
          ],
        ),
      )
    );
  }
}
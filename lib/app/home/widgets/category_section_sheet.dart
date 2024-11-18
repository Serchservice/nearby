import 'package:flutter/material.dart';
import 'package:drive/library.dart';

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
  }) => {
    Navigate.bottomSheet(
      sheet: CategorySectionSheet(category: category, onTap: onTap, selected: selected),
      route: "/${category.title}",
      isScrollable: true
    )
  };

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      margin: const EdgeInsets.all(16),
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
            const SizedBox(height: 20),
            Center(
              child: SText(
                text: category.title,
                color: Theme.of(context).primaryColor,
                size: Sizing.font(18),
                weight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Column(
              children: category.sections.map((option) {
                bool isSelected = selected.type == option.type;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Material(
                    color: isSelected
                        ? Theme.of(context).textSelectionTheme.selectionColor
                        : Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        onTap.call(option);
                        Navigate.back();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(Sizing.space(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(carDriveImage, width: 30),
                            const SizedBox(width: 12),
                            SText(
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
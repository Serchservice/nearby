import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class CategorySectionBox extends StatelessWidget {
  final CategorySection section;
  final Function(CategorySection) onClicked;

  const CategorySectionBox({super.key, required this.section, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: InkWell(
          onTap: () => onClicked(section),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                width: MediaQuery.sizeOf(context).width,
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(top: 24, bottom: 24, left: 8),
                decoration: BoxDecoration(gradient: LinearGradient(colors: section.colors)),
                child: Image(
                  image: AssetUtility.image(Assets.commonDriveWhite),
                  height: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextBuilder(
                        text: "Nearby ${section.description.toLowerCase()} around me",
                        size: 14,
                        color: Theme.of(context).primaryColor,
                        weight: FontWeight.bold,
                      ),
                    ),
                    Spacing.horizontal(6),
                    Icon(
                      Icons.arrow_right_alt_rounded,
                      size: 24,
                      color: Theme.of(context).primaryColorLight
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

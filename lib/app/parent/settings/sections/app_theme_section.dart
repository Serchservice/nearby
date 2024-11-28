import 'package:drive/library.dart';
import 'package:flutter/material.dart';

class AppThemeSection extends StatelessWidget {
  const AppThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SText(
            text: "Theme Setting",
            size: Sizing.font(14),
            color: Theme.of(context).primaryColorLight
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              child: Column(
                children: ThemeType.values.map((type) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => ParentController.data.updateTheme(type),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              type == ThemeType.light
                                ? Assets.themeWindowLight
                                : Assets.themeWindowDark,
                              width: 35
                            ),
                            const SizedBox(width: 10),
                            SText(
                              text: "${type.type} theme",
                              size: Sizing.font(14),
                              color: Theme.of(context).primaryColor
                            ),
                            Spacer(),
                            if(ParentController.data.state.theme.value == type) ...[
                              Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
                            ]
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

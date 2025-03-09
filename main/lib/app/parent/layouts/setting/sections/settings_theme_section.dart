import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:smart/smart.dart';

class SettingsThemeSection extends StatelessWidget {
  final SettingsController controller;

  const SettingsThemeSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextBuilder(
            text: "Theme Setting",
            size: Sizing.font(14),
            color: Theme.of(context).primaryColorLight
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              child: Column(
                children: ThemeType.values.map((type) {
                  return Obx(() {
                    ThemeType theme = controller.state.theme.value;
                    String asset = type.isLight ? SmartThemeAssets.light : SmartThemeAssets.dark;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => controller.updateTheme(type),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(asset, width: 35),
                              Spacing.horizontal(10),
                              TextBuilder(
                                text: "${type.type} theme",
                                size: Sizing.font(14),
                                color: Theme.of(context).primaryColor
                              ),
                              Spacer(),
                              if(theme == type) ...[
                                Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Theme.of(context).primaryColor)
                              ]
                            ],
                          ),
                        ),
                      ),
                    );
                  });
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
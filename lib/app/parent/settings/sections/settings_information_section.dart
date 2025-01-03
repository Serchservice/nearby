import 'package:drive/library.dart';
import 'package:flutter/material.dart';

class SettingsInformationSection extends StatelessWidget {
  final SettingsController controller;

  const SettingsInformationSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SText(
            text: "App Information",
            size: Sizing.font(14),
            color: Theme.of(context).primaryColorLight
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              child: Column(
                children: controller.appInformation.map((view) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => controller.handleAppInformation(view, context),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(view.icon, size: 28, color: Theme.of(context).primaryColor),
                            const SizedBox(width: 10),
                            SText(
                              text: view.header,
                              size: Sizing.font(14),
                              color: Theme.of(context).primaryColor
                            ),
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
import 'package:drive/library.dart';
import 'package:flutter/material.dart';

class SettingsHelpAndSupportSection extends StatelessWidget {
  final SettingsController controller;

  const SettingsHelpAndSupportSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SText(
            text: "Help and Support",
            size: Sizing.font(14),
            color: Theme.of(context).primaryColorLight
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Theme.of(context).textSelectionTheme.selectionColor,
              child: Column(
                children: controller.helpAndSupport.map((view) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => controller.handleHelpAndSupport(view),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                        child: Row(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(view.icon, size: 28, color: Theme.of(context).primaryColor),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SText(
                                    text: view.header,
                                    size: Sizing.font(14),
                                    color: Theme.of(context).primaryColor
                                  ),
                                  SText(
                                    text: view.body,
                                    size: Sizing.font(12),
                                    flow: TextOverflow.ellipsis,
                                    color: Theme.of(context).primaryColorLight
                                  ),
                                ],
                              ),
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
import 'package:drive/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingsAppDownloadSection extends StatelessWidget {
  final SettingsController controller;

  const SettingsAppDownloadSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if(kIsWeb) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SText(
              text: "It is more easier in the app",
              size: Sizing.font(14),
              color: Theme.of(context).primaryColorLight
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CentreNavigator(
                tab: ButtonView(
                  header: "Download the Nearby app",
                  body: "Click to download from your favorite stores",
                  image: Assets.logoAppIcon
                ),
                onTap: controller.onAppDownload,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

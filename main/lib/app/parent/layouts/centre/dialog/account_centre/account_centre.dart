import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show GetBuilder;
import 'package:smart/smart.dart';

import 'controllers/account_centre_controller.dart';

class AccountCentre extends StatelessWidget {
  const AccountCentre({super.key});

  static void open() {
    Navigate.bottomSheet(
      sheet: AccountCentre(),
      route: Navigate.appendRoute("/account_centre"),
      background: Colors.transparent,
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      padding: EdgeInsets.zero,
      height: MediaQuery.sizeOf(context).height / 1.5,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      uiConfig: UiConfig(
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Database.instance.isLightTheme ? Brightness.dark : Brightness.light,
      ),
      child: GetBuilder<AccountCentreController>(
        init: AccountCentreController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(PlatformEngine.instance.isWeb) ...[
                  GoBack(onTap: () => Navigate.close(closeAll: false)),
                ] else ...[
                  ModalBottomSheetIndicator(
                    showButton: false,
                    color: CommonColors.instance.darkTheme2,
                    backgroundColor: CommonColors.instance.lightTheme2,
                  )
                ],
                Image.asset(
                  Assets.animGoBeyond,
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.sizeOf(context).width,
                  height: 200,
                ),
                Spacing.vertical(20),
                Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.tabs.map((ButtonView tab) {
                    return SmartButton(
                      tab: tab,
                      color: tab.color,
                      onTap: tab.onClick,
                    );
                  }).toList(),
                )
              ],
            ),
          );
        }
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drive/library.dart';

class PermissionSheet extends StatelessWidget {
  final int sdk;
  const PermissionSheet({super.key, required this.sdk});

  static void open({required int sdk}) {
    Navigate.bottomSheet(sheet: PermissionSheet(sdk: sdk), route: "/permission/dialog", isScrollable: true);
  }

  @override
  Widget build(BuildContext context) {
    return GetX<PermissionSheetController>(
      init: PermissionSheetController(sdk: sdk),
      builder: (controller) {
        return PopScope(
          canPop: controller.state.canPop.value,
          child: CurvedBottomSheet(
            safeArea: true,
            margin: const EdgeInsets.all(16),
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(24),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image(
                        image: AssetUtility.image(Assets.mapWorld),
                        height: 200,
                        width: MediaQuery.sizeOf(context).width,
                      ),
                    ),
                    SText(
                      text: "In order to give you a smooth user experience, Serch requires some basic permissions to be granted.",
                      size: Sizing.font(16),
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 10),
                    SText(
                      text: "Some required permissions include:",
                      size: Sizing.font(12),
                      color: Theme.of(context).primaryColor,
                    ),
                    ...[
                      "Location",
                      "and others"
                    ].map((item) {
                      return SText(
                        text: "* $item",
                        size: Sizing.font(12),
                        color: Theme.of(context).primaryColor,
                      );
                    }),
                    const SizedBox(height: 40),
                    Center(
                      child: LoadingButton(
                        text: "Grant permissions",
                        borderRadius: 24,
                        width: MediaQuery.sizeOf(context).width,
                        textSize: Sizing.font(14),
                        buttonColor: CommonColors.darkTheme2,
                        textColor: CommonColors.lightTheme,
                        onClick: () => controller.grant(),
                      ),
                    )
                  ],
                ),
              ),
            )
          ),
        );
      }
    );
  }
}

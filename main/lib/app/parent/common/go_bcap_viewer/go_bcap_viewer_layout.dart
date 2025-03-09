import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

import 'controllers/go_bcap_viewer_controller.dart';

class GoBCapViewerLayout extends GetView<GoBCapViewerController> {
  static String get route => "/bcap/:id";

  const GoBCapViewerLayout({super.key});

  static void open({GoBCap? cap, String? capId, required GoBCapUpdated onUpdated}) {
    String id = "";
    if(cap.isNotNull) {
      id = cap!.id;
    } else if(capId.isNotNull) {
      id = capId!;
    }

    Map<String, dynamic> arguments = {
      "on_updated": onUpdated
    };
    if(cap.isNotNull) {
      arguments["cap"] = cap;
    }

    if(id != "") {
      Navigate.to("/bcap/$id", arguments: arguments);
    } else {
      Navigate.all(PageNotFoundLayout.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isLoading = controller.state.isLoading.value;
      GoBCap cap = controller.state.cap.value;

      return LayoutWrapper(
        layoutKey: Key("bcap-viewer"),
        child: BannerAdLayout(
          child: Stack(
            children: [
              if(isLoading) ...[
                GoBCapCardLoading()
              ] else ...[
                GoBCapCard(cap: cap, id: "bcap-viewer")
              ],
              Positioned(
                top: 4,
                left: 4,
                right: 4,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Row(
                    children: [
                      GoBack(
                        onTap: () {
                          if(Navigate.previousRoute.equals("/") || Navigate.previousRoute.isEmpty) {
                            Navigate.all(ParentLayout.route);
                          } else {
                            Navigate.close(closeAll: false);
                          }
                        },
                        color: CommonColors.instance.lightTheme,
                      ),
                      TextBuilder(
                        text: isLoading ? "Loading..." : cap.name,
                        size: Sizing.font(16),
                        weight: FontWeight.bold,
                        color: CommonColors.instance.lightTheme,
                      ),
                    ],
                  )
                )
              ),
            ],
          ),
        )
      );
    });
  }
}
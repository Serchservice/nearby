import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter/webview_flutter.dart';
import 'package:drive/library.dart';

/// Parameters: {"reference": "(For payment)", "header": "(Any preferred header)", "url": "(Route to visit)"}
class WebLayout extends GetView<WebController> {
  static const String route = "/web";

  const WebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigate.back(
            result: controller.state.response.value
          ),
          icon: Icon(
            CupertinoIcons.chevron_back,
            color: Theme.of(context).primaryColor,
            size: Sizing.font(28)
          )
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => SText(
              text: controller.state.header.value,
              color: Theme.of(context).primaryColor,
              size: Sizing.font(14),
              weight: FontWeight.bold
            )),
            Obx(() => SText(
              text: controller.state.route.value,
              color: Theme.of(context).primaryColor,
              size: Sizing.font(12),
              weight: FontWeight.bold
            )),
          ]),
        actions: [
          WebControls(controller: controller.controller)
        ],
      ),
      body: webViewBody(controller)
    );
  }

  Widget webViewBody(WebController controller) {
    return Obx(() {
      if(controller.state.loadingPercentage.value < 100) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Loading(
                color: Get.theme.primaryColor,
                size: 30
              ),
              const SizedBox(height: 5),
              SText(
                text: "Loading ${controller.state.loadingPercentage.value.toString()}%",
                color: Get.theme.primaryColor,
                size: Sizing.font(16),
                weight: FontWeight.bold,
              )
            ]
          )
        );
      } else if(controller.state.loadingPercentage.value >= 100) {
        return WebViewWidget(controller: controller.controller);
      } else {
        return Center(
          child: SText(
            text: controller.state.errorMessage.value,
            color: CommonColors.darkTheme,
            size: Sizing.font(16)
          )
        );
      }
    });
  }
}
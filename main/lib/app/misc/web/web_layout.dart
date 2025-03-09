import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter/webview_flutter.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

/// Parameters: {"reference": "(For payment)", "header": "(Any preferred header)", "url": "(Route to visit)"}
class WebLayout extends GetView<WebController> {
  static const String route = "/web";

  const WebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      layoutKey: Key("Webview"),
      appbar: AppBar(
        leading: IconButton(
          onPressed: () => Navigate.back(result: controller.state.response.value),
          icon: Icon(
            CupertinoIcons.chevron_back,
            color: Theme.of(context).primaryColor,
            size: Sizing.font(28)
          )
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => TextBuilder(
              text: controller.state.header.value,
              color: Theme.of(context).primaryColor,
              size: Sizing.font(14),
              weight: FontWeight.bold
            )),
            Obx(() => TextBuilder(
              text: controller.state.route.value,
              color: Theme.of(context).primaryColor,
              size: Sizing.font(12),
              weight: FontWeight.bold
            )),
          ]),
        actions: [
          MenuAnchor(
            builder: (BuildContext context, MenuController controller, Widget? child) {
              return InkWell(
                onTap: controller.isOpen ? controller.close : controller.open,
                child: Icon(
                  Icons.more_vert_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 20
                ),
              );
            },
            style: MenuStyle(
              backgroundColor: WidgetStateProperty.all(Theme.of(context).scaffoldBackgroundColor),
              padding: WidgetStateProperty.all(EdgeInsets.zero),
            ),
            menuChildren: [
              ...controller.menuItems.map((menu) {
                return MenuItemButton(
                  onPressed: menu.onClick,
                  child: TextBuilder(
                    text: menu.header,
                    color: Theme.of(context).primaryColor,
                    size: 14,
                    autoSize: false,
                  ),
                );
              }),
              MenuItemButton(child: WebControls(controller: controller.controller))
            ],
          ),
        ],
      ),
      child: Obx(() {
        if(controller.state.loadingPercentage.value.isLessThan(100)) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Loading.circular(color: Get.theme.primaryColor, size: 30),
                Spacing.vertical(5),
                TextBuilder(
                  text: "Loading ${controller.state.loadingPercentage.value.toString()}%",
                  color: Get.theme.primaryColor,
                  size: Sizing.font(16),
                  weight: FontWeight.bold,
                )
              ]
            )
          );
        } else if(controller.state.loadingPercentage.value.isGreaterThanOrEqualTo(100)) {
          return WebViewWidget(controller: controller.controller);
        } else {
          return Center(
            child: TextBuilder(
              text: controller.state.errorMessage.value,
              color: CommonColors.instance.darkTheme,
              size: Sizing.font(16)
            )
          );
        }
      })
    );
  }
}
import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreLayout extends GetResponsiveView<ExploreController> {
  static String get route => "/explore";

  ExploreLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      layoutKey: Key("Explore"),
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Explore Marketplace",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(Sizing.space(12)),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(Sizing.space(10)),
                      decoration: BoxDecoration(
                        color: Theme.of(context).textSelectionTheme.selectionColor,
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: SText(
                        text: "Explore other Serchservice mobile applications tailored at providing ease and comfort, anywhere you are.",
                        size: Sizing.font(14),
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      runAlignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      runSpacing: 15,
                      children: controller.apps.map((app) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: CommonColors.shimmer)
                          ),
                          height: 120,
                          width: MediaQuery.sizeOf(context).width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => controller.open(app.index),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetUtility.image(app.asset),
                                      width: 120,
                                      height: 120
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SText(
                                              text: app.header,
                                              size: Sizing.font(16),
                                              color: Theme.of(context).primaryColor
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            color: Theme.of(context).appBarTheme.backgroundColor,
                                            child: SText(
                                              text: app.body,
                                              size: Sizing.font(12),
                                              color: Theme.of(context).primaryColorLight
                                            ),
                                          ),
                                        ],
                                      )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if(controller.bannerAdManager.banner() != null) ...[
            controller.bannerAdManager.banner()!
          ]
        ],
      )
    );
  }
}
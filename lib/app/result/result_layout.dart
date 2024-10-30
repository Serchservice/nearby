import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultLayout extends GetResponsiveView<ResultController> {
  static String get route => "/result";

  ResultLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      layoutKey: Key("Result"),
      appbar: AppBar(
        elevation: 0.5,
        title: Obx(() => SText.center(
          text: controller.state.title.value,
          size: Sizing.font(16),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        )),
        actions: [
          IconButton(
            onPressed: () => ResultFilterSheet.open(
              list: controller.driveFilters,
              selectedIndex: controller.state.filter.value,
              onUpdate: controller.updateSearch,
              radius: controller.state.radius.value
            ),
            icon: Icon(
              Icons.filter_list_rounded,
              color: Theme.of(context).primaryColor
            )
          )
        ]
      ),
      child: Column(
        children: [
          Expanded(
            child: _buildBody(
              context: context,
              child: Obx(() {
                if(controller.state.sortedShops.isEmpty) {
                  return Center(
                    child: SText(
                      text: controller.noResult(),
                      size: Sizing.font(16),
                      color: Theme.of(context).primaryColor,
                    )
                  );
                } else {
                  return ListView.builder(
                    itemCount: controller.state.sortedShops.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(6),
                    itemBuilder: (context, index) {
                      return ResultView(
                        shop: controller.state.sortedShops[index],
                        controller: controller,
                      );
                    }
                  );
                }
              })
            ),
          ),
          HomeController.data.banner()
        ],
      )
    );
  }

  Obx _buildBody({required BuildContext context, required Widget child}) {
    return Obx(() {
      if(controller.state.isSearching.value) {
        return LoadingShimmer(
          content: Column(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                margin: EdgeInsets.all(Sizing.space(10)),
                padding: EdgeInsets.all(Sizing.space(20)),
                decoration: BoxDecoration(
                  color: CommonColors.shimmerHigh,
                  borderRadius: BorderRadius.circular(6)
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(6),
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.sizeOf(context).width,
                      margin: EdgeInsets.only(bottom: Sizing.space(4)),
                      height: 90,
                      color: CommonColors.shimmerHigh,
                    );
                  }
                ),
              ),
            ],
          )
        );
      } else {
        return child;
      }
    });
  }
}
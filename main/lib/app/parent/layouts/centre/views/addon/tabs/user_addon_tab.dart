import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';
import 'package:get/get.dart' show Obx;

import 'card/go_user_addon_card.dart';

class UserAddonTab extends StatelessWidget {
  final AddonController controller;
  const UserAddonTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BannerAdLayout(
      child: Obx(() {
        if(controller.state.isFetchingMine.value) {
          return _Loading();
        } else if(controller.state.userAddons.isEmpty) {
          return _Empty(onRefresh: controller.fetchUserAddons);
        } else {
          return PullToRefresh(
            onRefreshed: controller.fetchUserAddons,
            child: _List(controller: controller)
          );
        }
      })
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LoadingShimmer(
        isDarkMode: Database.instance.isDarkTheme,
        content: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: 6.listGenerator.map((int index) {
                    return Container(
                      width: 350,
                      height: 250,
                      decoration: BoxDecoration(
                        color: CommonColors.instance.shimmerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }).toList(),
                )
              ),
              ...6.listGenerator.map((int index) {
                return Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: CommonColors.instance.shimmerHigh,
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              })
            ],
          )
        )
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final VoidCallback onRefresh;

  const _Empty({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.2,
              child: Icon(
                Icons.extension_off_rounded,
                color: Theme.of(context).primaryColor,
                size: 100
              )
            ),
            TextBuilder.center(
              text: "No addons found",
              autoSize: false,
              color: Theme.of(context).primaryColor,
            ),
            TextButton(
              onPressed: onRefresh,
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.resolveWith((states) {
                  return CommonColors.instance.bluish.lighten(48);
                }),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 6))
              ),
              child: TextBuilder(
                text: "Refresh",
                weight: FontWeight.bold,
                color: CommonColors.instance.bluish
              )
            )
          ],
        )
      )
    );
  }
}

class _List extends StatelessWidget {
  final AddonController controller;
  const _List({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(controller.state.userCards.isNotEmpty) ...[
              Column(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBuilder(
                    text: "Cards",
                    weight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    size: 16,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: controller.state.userCards.map((GoCreditCard card) => GoCreditCardItem(card: card)).toList(),
                    )
                  )
                ]
              )
            ],
            Spacing.vertical(20),
            TextBuilder(
              text: "Addons",
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              size: 16,
            ),
            Spacing.vertical(5),
            ...controller.state.userAddons.map((GoUserAddon addon) {
              return GoUserAddonCard(
                addon: addon,
                onUpdated: (GoUserAddon update) {}
              );
            })
          ]
        )
      ),
    );
  }
}
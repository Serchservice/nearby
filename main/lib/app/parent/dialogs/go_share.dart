import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class GoShare<T> extends StatelessWidget {
  final T data;
  const GoShare({super.key, required this.data});

  static void open<T>(T data) {
    if(data.instanceOf<GoActivity>() || data.instanceOf<GoBCap>()) {
      GoActivity? activity = data.instanceOf<GoActivity>() ? data as GoActivity : null;
      GoBCap? bcap = data.instanceOf<GoBCap>() ? data as GoBCap : null;

      String route = activity.isNotNull ? activity!.id : bcap!.id;
      Navigate.bottomSheet(
        sheet: GoShare<T>(data: data),
        route: Navigate.appendRoute("/share?with=$route"),
        isScrollable: true
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    GoActivity? activity = data.instanceOf<GoActivity>() ? data as GoActivity : null;
    GoBCap? bcap = data.instanceOf<GoBCap>() ? data as GoBCap : null;

    GoInterest? interest = activity?.interest ?? bcap?.interest;
    String link = activity?.link ?? bcap?.link ?? "";
    String shareMessage = activity.isNotNull
      ? "🚀 Check out this activity: ${activity!.name}!"
      : bcap.isNotNull
      ? "✨ Discover this amazing activity-filled experience: ${bcap!.name}."
      : "🔗 Check this out: $link";

    return ModalBottomSheet(
      padding: EdgeInsets.zero,
      sheetPadding: EdgeInsets.all(12),
      useSafeArea: (config) => config.copyWith(top: true),
      uiConfig: UiConfig(
        systemNavigationBarColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      child: SingleChildScrollView(
        child: BannerAdLayout(
          expandChild: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ModalBottomSheetIndicator(showButton: false, margin: 0),
              GoBack(onTap: () => Navigate.close(closeAll: false), size: 25),
              Image.asset(
                Assets.animGoBeyond,
                fit: BoxFit.fitWidth,
                width: MediaQuery.sizeOf(context).width,
                height: 200,
              ),
              Spacing.vertical(20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.logoFavicon,
                      width: 35,
                      height: 35,
                    ),
                    if(interest.isNotNull) ...[
                      Expanded(child: InterestViewer.view(interest: interest!)),
                    ]
                  ],
                ),
              ),
              Spacing.vertical(30),
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                width: MediaQuery.sizeOf(context).width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SmartShare.list(
                    isDarkMode: Database.instance.isDarkTheme,
                    spacing: 10,
                    config: SmartShareConfig(
                      message: shareMessage,
                      data: link,
                    ),
                    globalConfiguration: (SmartShareItemConfig config, int index) {
                      return config.copyWith(
                        textColor: Theme.of(context).primaryColor,
                        tapColor: Colors.transparent,
                        textWeight: FontWeight.normal,
                        itemSize: 20,
                        padding: EdgeInsets.all(8),
                        color: Theme.of(context).primaryColor,
                      );
                    },
                    onItemClicked: (SmartShareItem item, String content) {
                      if(item.isCopy) {
                        CommonUtility.copy(content);
                      } else if(item.isShare) {
                        // Share.share(content);
                      } else {
                        console.log(content);
                        RouteNavigator.openLink(url: content);
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
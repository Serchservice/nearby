import 'package:drive/library.dart';
import 'package:smart/smart.dart';
import 'package:flutter/material.dart';

class InterestViewerSheet extends StatelessWidget {
  final GoInterest interest;
  final bool isClickable;
  final VoidCallback? onClick;
  final Color? buttonColor;
  final String buttonText;

  const InterestViewerSheet({
    super.key,
    required this.interest,
    this.onClick,
    this.buttonColor,
    this.isClickable = true,
    this.buttonText = "Add interest"
  });

  static void open({
    required GoInterest interest,
    bool isClickable = true,
    VoidCallback? onClick,
    Color? buttonColor,
    String buttonText = "Add interest"
  }) {
    Navigate.bottomSheet(
      sheet: InterestViewerSheet(
        interest: interest,
        isClickable: isClickable,
        onClick: onClick,
        buttonColor: buttonColor,
        buttonText: buttonText
      ),
      route: Navigate.appendRoute("/more"),
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    Color buttonColor = this.buttonColor ?? CommonColors.instance.color;
    Color buttonTextColor = buttonColor.isWhiteRange()
      ? buttonColor.lighten(30)
      : CommonColors.instance.lightTheme;

    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      sheetPadding: EdgeInsets.all(10),
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(24),
      uiConfig: UiConfig(
        systemNavigationBarColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      child: SingleChildScrollView(
        child: BannerAdLayout(
          mainAxisSize: MainAxisSize.min,
          expandChild: false,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 4, left: 4, right: 4),
                child: Row(
                  children: [
                    GoBack(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBuilder(
                          text: interest.title,
                          size: Sizing.font(18),
                          weight: FontWeight.bold,
                          color: Theme.of(context).primaryColor
                        ),
                        TextBuilder(
                          text: interest.category,
                          size: 11,
                          autoSize: false,
                          color: Theme.of(context).primaryColor,
                          flow: TextOverflow.ellipsis
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                padding: EdgeInsets.all(10),
                color: CommonColors.instance.bluish.darken(10),
                child: Column(
                  spacing: 10,
                  children: [
                    SmartPoll(
                      pollEnded: true,
                      metadata: SmartPollMetadata(shouldShow: false),
                      configBuilder: (config, index) {
                        return config.copyWith(
                          useText: true,
                          text: index.equals(0) ? interest.popularity.prettyFormat : interest.nearbyPopularity.prettyFormat,
                          style: TextStyle(color: CommonColors.instance.lightTheme),
                          leadingVotedProgressColor: CommonColors.instance.bluish.lighten(10),
                          votedBackgroundColor: CommonColors.instance.bluish,
                          votedRadius: Radius.circular(48)
                        );
                      },
                      options: [
                        SmartPollOption(id: 0, votes: interest.popularity, description: "General Popularity"),
                        SmartPollOption(id: 1, votes: interest.nearbyPopularity, description: "Nearby Popularity")
                      ],
                    ),
                    if(isClickable) ...[
                      InteractiveButton(
                        text: buttonText,
                        borderRadius: 24,
                        width: MediaQuery.sizeOf(context).width,
                        textSize: Sizing.font(14),
                        buttonColor: buttonColor,
                        textColor: buttonTextColor,
                        onClick: onClick,
                      )
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
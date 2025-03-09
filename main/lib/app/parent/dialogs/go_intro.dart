import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class GoIntro extends StatelessWidget {
  const GoIntro({super.key});

  static void open() {
    Navigate.bottomSheet(
      sheet: GoIntro(),
      route: Navigate.appendRoute("/auth/intro"),
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
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
              Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.logoFavicon,
                    width: 40,
                    height: 40,
                  ),
                  Expanded(
                    child: TextBuilder(
                      text: "An amazing world of possibilities and wonders, waits for your majestic entrance.",
                      color: Theme.of(context).primaryColor,
                      size: Sizing.font(14),
                    ),
                  ),
                ],
              ),
              Spacing.vertical(30),
              Row(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextBuilder(
                    text: "Already have an account?",
                    color: Theme.of(context).primaryColor
                  ),
                  TextButton(
                    onPressed: LoginSheet.open,
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.resolveWith((states) {
                        return Database.instance.isLightTheme
                            ? Theme.of(context).primaryColor.lighten(88)
                            : CommonColors.instance.darkTheme2.lighten(28);
                      }),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                      padding: WidgetStateProperty.all(EdgeInsets.zero)
                    ),
                    child: TextBuilder(
                      text: "Login",
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    )
                  )
                ],
              ),
              Spacing.vertical(30),
              InteractiveButton(
                text: "Create account",
                borderRadius: 24,
                width: MediaQuery.sizeOf(context).width,
                textSize: Sizing.font(14),
                buttonColor: CommonColors.instance.color,
                textColor: CommonColors.instance.lightTheme,
                onClick: SignupSheet.open,
              )
            ],
          ),
        ),
      )
    );
  }
}
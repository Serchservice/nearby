import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

class SignOut extends StatefulWidget {
  const SignOut({super.key});

  static void open() {
    Navigate.bottomSheet(
      sheet: SignOut(),
      route: Navigate.appendRoute("/sign_out"),
      isScrollable: true
    );
  }

  @override
  State<SignOut> createState() => _SignOutState();
}

class _SignOutState extends State<SignOut> {
  bool _isLoading = false;

  void _signOut() async {
    setState(() => _isLoading = true);

    Database.instance.clearAll();
    setState(() => _isLoading = false);
    ActivityLifeCycle.onSignOut();
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: BannerAdLayout(
          expandChild: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(Sizing.space(2)),
                  width: 60,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(16)
                  ),
                ),
              ),
              Spacing.vertical(20),
              TextBuilder(
                text: "Sign out!",
                color: Theme.of(context).primaryColor,
                size: Sizing.font(22),
                weight: FontWeight.bold,
              ),
              TextBuilder(
                text: "You'll be logged out automatically from this device.",
                color: Theme.of(context).primaryColor,
                size: Sizing.font(14),
              ),
              Spacing.vertical(30),
              InteractiveButton(
                text: "Yes, continue",
                borderRadius: 24,
                width: MediaQuery.sizeOf(context).width,
                textSize: Sizing.font(14),
                buttonColor: CommonColors.instance.color,
                textColor: CommonColors.instance.lightTheme,
                onClick: _signOut,
                loading: _isLoading,
              )
            ],
          ),
        ),
      )
    );
  }
}
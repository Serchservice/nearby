import 'package:flutter/material.dart';
import 'package:drive/library.dart';

class PageNotFoundLayout extends StatelessWidget {
  static const String route = "/page/error/404";
  const PageNotFoundLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Padding(
        padding: EdgeInsets.all(Sizing.space(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              Assets.logoSplashWhite,
              width: 100,
              color: Theme.of(context).primaryColor,
            ),
            LineHeader(
              header: "Page Not Found (404)",
              footer: "Oops. We couldn't find the page you looked for.",
              color: Theme.of(context).primaryColor,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Image.asset(
                  Assets.logoSmeBlack,
                  width: 150,
                  color: Theme.of(context).primaryColor
                ),
              ),
            )
          ]
        ),
      )
    );
  }
}
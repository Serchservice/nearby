import 'package:drive/library.dart';
import 'package:flutter/material.dart';
import 'package:smart/utilities.dart';

class LogoLink extends StatelessWidget {
  const LogoLink({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => RouteNavigator.openWeb(header: "Serchservice", url: LinkUtils.instance.baseUrl),
      child: Image.asset(
        Assets.logoLogo,
        width: 100,
        height: 40,
        fit: BoxFit.contain,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
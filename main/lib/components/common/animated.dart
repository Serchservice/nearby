import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:smart/ui.dart';

class Animated extends StatelessWidget {
  const Animated({
    super.key,
    required this.toWidget,
    this.route = "",
    required this.child,
    this.color,
    this.transition,
    this.borderRadius,
    this.elevation = 4.0,
    this.openElevation = 4.0,
    this.params
  });

  final Widget toWidget;
  final ContainerTransitionType? transition;
  final String route;
  final Map<String, dynamic>? params;
  final Widget child;
  final Color? color;
  final double elevation;
  final double openElevation;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    // Coalesce params into a query string if not null
    String param = params != null ? _getQueryString(params!) : "";
    String routeName = "$route$param";

    if(PlatformEngine.instance.isMobile) {
      return OpenContainer(
        transitionType: transition ?? ContainerTransitionType.fade,
        openBuilder: (BuildContext context, VoidCallback _) {
          return toWidget;
        },
        routeSettings: RouteSettings(name: routeName),
        closedElevation: elevation,
        openElevation: openElevation,
        closedShape: RoundedRectangleBorder(borderRadius: borderRadius ?? BorderRadius.circular(24)),
        closedColor: color ?? Theme.of(context).colorScheme.surface,
        closedBuilder: (BuildContext context, VoidCallback openContainer) => child,
      );
    } else {
      return InfoButton(
        onPressed: () => Navigate.toPage(widget: toWidget, route: route),
        icon: child,
        tip: "",
      );
    }
  }

  String _getQueryString(Map<String, dynamic> params) {
    return params.entries.map((e) {
      return "${e.key}=${Uri.encodeComponent(e.value.toString())}";
    }).join("&");
  }
}
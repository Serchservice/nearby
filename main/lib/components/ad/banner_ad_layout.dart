import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class BannerAdLayout extends StatelessWidget {
  final Widget child;
  final bool isExpanded;
  final bool expandChild;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;

  const BannerAdLayout({
    super.key,
    required this.child,
    this.isExpanded = false,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.expandChild = true
  });

  @override
  Widget build(BuildContext context) {
    if(isExpanded) {
      return Expanded(child: _build(context));
    } else {
      return _build(context);
    }
  }

  Widget _build(BuildContext context) {
    return Obx(() {
      if(ParentController.data.state.showAds.value) {
        return child;
      } else {
        return Column(
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
          mainAxisSize: mainAxisSize ?? MainAxisSize.max,
          children: [
            if(expandChild) ...[
              Expanded(child: child),
            ] else ...[
              child,
            ],
            BannerAdWidget(),
          ],
        );
      }
    });
  }
}
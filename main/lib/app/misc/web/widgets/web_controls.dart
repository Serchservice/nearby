import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter/webview_flutter.dart';

class WebControls extends StatelessWidget {
  const WebControls({required this.controller, super.key});

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).primaryColor
          ),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await controller.canGoBack()) {
              await controller.goBack();
            } else {
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('No back history item'),
                  duration: Duration(seconds: 1)
                )
              );
              return;
            }
          },
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).primaryColor
          ),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await controller.canGoForward()) {
              await controller.goForward();
            } else {
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('No forward history item'),
                  duration: Duration(seconds: 1)
                )
              );
              return;
            }
          },
        ),
        IconButton(
          icon: Icon(
            Icons.replay,
            color: Theme.of(context).primaryColor
          ),
          onPressed: () => controller.reload()
        ),
      ]
    );
  }
}
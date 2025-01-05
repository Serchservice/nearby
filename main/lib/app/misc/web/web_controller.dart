// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:drive/library.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebController extends GetxController {
  WebController();
  final state = WebState();

  final _params = Get.arguments;
  final _param = Get.parameters;

  late final WebViewController controller;

  @override
  void onInit() {
    if(_params != null && _params[0] != null && _params[0] is Uri) {
      // final header = Uri()
    }

    state.response.value = _param["reference"] ?? "";
    state.route.value = _param["url"] ?? "";
    state.header.value = _param["header"] ?? "";
    loadWeb();

    super.onInit();
  }

  void showErrorMessage(String message) {
    notify.tip(message: message, color: CommonColors.error);
  }

  void toast(String message) {
    notify.tip(message: message);
  }

  void loadWeb() async {
    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    controller = WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            state.loadingPercentage.value = progress;
          },
          onPageStarted: (String url) {
            state.route.value = url;
            updateTitle();
          },
          onPageFinished: (String url) {
            state.route.value = url;
            updateTitle();
          },
          onWebResourceError: (WebResourceError error) {
            showErrorMessage(error.description);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            if (request.url.startsWith('https://www.serchservice.com/payment/verify')) {
              Navigate.back(result: state.response.value);
              return NavigationDecision.prevent;
            }
            if(request.url == 'https://standard.paystack.co/close'){
              Navigate.back(result: state.response.value);
            }
            return NavigationDecision.navigate;
          },
          // onHttpError: (HttpResponseError error) {
          //   debugPrint('Error occurred on page: ${error.response?.statusCode}');
          // },
          onUrlChange: (UrlChange change) {
            if(change.url != null) {
              state.route.value = change.url!;
            }
            updateTitle();
          },
          onHttpAuthRequest: (HttpAuthRequest request) {
            showErrorMessage("Authentication is required");
          },
        ),
      )
      ..addJavaScriptChannel('Toaster', onMessageReceived: (JavaScriptMessage message) => toast(message.message))
      ..loadRequest(Uri.parse(state.route.value.isEmpty ? "https://serchservice.com" : state.route.value));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(false);
      (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features
  }

  void updateTitle() async {
    final title = await controller.getTitle();
    if(title != null) {
      state.header.value = title;
    }
  }
}
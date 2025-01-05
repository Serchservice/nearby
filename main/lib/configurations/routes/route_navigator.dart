import 'package:url_launcher/url_launcher.dart';
import 'package:drive/library.dart';

class RouteNavigator {
  static Future<void> callNumber(String phoneNumber) async {
    await launchUrl(Uri(scheme: 'tel', path: phoneNumber));
  }

  static Future<void> openLink({Uri? uri, String? url}) async {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      uri ?? Uri.parse(url!),
      mode: LaunchMode.externalNonBrowserApplication
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(uri ?? Uri.parse(url!), mode: LaunchMode.inAppWebView,);
    }
  }

  static Future<void> mail(String mailAddress) async {
    await launchUrl(Uri(scheme: "mailto", path: mailAddress));
  }

  static Future<T?>? openWeb<T>({
    required String header,
    required String url,
    Map<String, String>? params,
    Object? arguments
  }) async {
    if(PlatformEngine.instance.isWeb) {
      openLink(url: url);

      return null;
    } else {
      Map<String, String> parameters = {
        "header": header,
        "url": url,
      };
      if(params != null && params.isNotEmpty) {
        params.forEach((key, value) {
          parameters.putIfAbsent(key, () => value);
        });
      }

      return Navigate.to(WebLayout.route, parameters: parameters, arguments: arguments);
    }
  }
}
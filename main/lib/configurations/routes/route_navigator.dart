import 'package:url_launcher/url_launcher.dart';
import 'package:drive/library.dart';

class RouteNavigator {
  static Future<void> callNumber(String phoneNumber) async {
    Uri path = Uri(scheme: 'tel', path: phoneNumber);

    try {
      await launchUrl(path);
    } catch (_) {
      notify.tip(message: "Couldn't open phone number. Copying details to clipboard");
      CommonUtility.copy(phoneNumber);
    }
  }

  static void openLink({Uri? uri, String? url}) async {
    Uri path = uri ?? Uri.parse(url!);

    try {
      final bool nativeAppLaunchSucceeded = await launchUrl(path, mode: LaunchMode.externalApplication);
      if (!nativeAppLaunchSucceeded) {
        await launchUrl(path, mode: LaunchMode.inAppWebView,);
      }
    } catch (_) {
      notify.tip(message: "Couldn't open url. Copying url to clipboard");
      CommonUtility.copy(path.toString());
    }
  }

  static Future<void> mail(String mailAddress) async {
    Uri path = Uri(scheme: "mailto", path: mailAddress);

    try {
      await launchUrl(path);
    } catch (_) {
      notify.tip(message: "Couldn't open email address. Copying details to clipboard");
      CommonUtility.copy(mailAddress);
    }
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
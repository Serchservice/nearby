import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class AppImplementation implements AppService {
  final AppLinks _appLinks = AppLinks();
  final ConnectService _connect = Connect();
  final FirebaseMessagingService _messagingService = FirebaseMessagingImplementation();

  @override
  Future<StreamSubscription<Uri>> initializeDeepLink() async {
    // Check initial link if app was in cold state (terminated)
    final appLink = await _appLinks.getInitialLink();
    if (appLink != null) {
      String formattedPath = "${appLink.path}?${appLink.query}";

      console.log('getInitialAppLink: $appLink | $formattedPath');
      openAppLink(appLink);
    }

    StreamSubscription<Uri> subscription = _appLinks.uriLinkStream.listen((uri) {
      String formattedPath = "${uri.path}?${uri.query}";

      console.log('getAppLink: $uri | $formattedPath');
      openAppLink(uri);
    });

    return subscription;
  }

  @override
  void openAppLink(Uri uri) {
    final txref = uri.queryParameters['txref'];
    final reference = uri.queryParameters['reference'];
    console.log('txref: $txref | reference: $reference');

    if(reference != null) {
      VerifyTransaction.open(reference);
    } else if(txref != null) {
      VerifyTransaction.open(txref);
    }
  }

  @override
  void checkUpdate() async {
    if(!PlatformEngine.instance.isWeb) {
      try {
        InAppUpdate.checkForUpdate().then((AppUpdateInfo info) {
          if(info.updateAvailability == UpdateAvailability.updateAvailable) {
            InAppUpdate.startFlexibleUpdate().then((AppUpdateResult result) {
              if(result == AppUpdateResult.success) {
                InAppUpdate.completeFlexibleUpdate();
              }
            });
          }
        });
      } catch (e) {
        console.log('Check update failed', from: "[APP IMPLEMENTATION]");
        console.error(e, from: "[APP IMPLEMENTATION]");
      }
    }
  }

  @override
  void registerDevice() async {
    String fcmToken = await _messagingService.getFcmToken();

    JsonMap payload = PlatformEngine.instance.device.toJson();
    payload.putIfAbsent("fcm_token", () => fcmToken);
    payload.putIfAbsent("id", () => Database.instance.preference.id.isEmpty ? null : Database.instance.preference.id);

    _connect.post(endpoint: "/auth/nearby/register", body: payload).then((Outcome response) {
      if(response.isSuccessful) {
        Database.instance.savePreference(Database.instance.preference.copyWith(id: response.data));
      }
    });
  }
}
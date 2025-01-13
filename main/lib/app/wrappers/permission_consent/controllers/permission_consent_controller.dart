import 'dart:async';

import 'package:drive/library.dart';

class PermissionConsentController {
  PermissionConsent? _consent;
  PermissionConsent get consent => _consent ?? PermissionConsent(sdk: 0, show: false, canPop: true);

  final StreamController<PermissionConsent> _consentController = StreamController.broadcast();
  Stream<PermissionConsent> get consentStream => _consentController.stream;

  final AccessService _accessService = AccessImplementation();

  void init() {
    _runCheck();
  }

  void _runCheck() async {
    Device device = PlatformEngine.instance.device;

    if(!await _accessService.hasLocation()) {
      PermissionConsent consent = PermissionConsent(sdk: device.sdk, show: true, canPop: false);

      _consent = consent;
      Future.microtask(() => _consentController.add(consent));
    }

    AnalyticsEngine.logEvent("DEVICE_INFORMATION", parameters: device.toJson());
  }

  void grant() {
    PermissionConsent update = consent.copyWith(canPop: false);

    _consent = update;
    _consentController.add(update);
    requestAccess(onSuccess: () async {
      PermissionConsent event = update.copyWith(canPop: true, show: false);
      _consent = event;
      _consentController.add(event);
    });
  }

  Future<void> requestAccess({Function()? onSuccess}) async {
    bool hasAccess = await _accessService.requestPermissions();
    if(hasAccess) {
      if(PlatformEngine.instance.isMobile || PlatformEngine.instance.isWeb) {
        onSuccess?.call();
        return;
      } else {
        throw SerchException("Unsupported platform", isPlatformNotSupported: true);
      }
    } else {
      requestAccess(onSuccess: onSuccess);
    }
  }

  void dispose() {
    _consentController.close();
  }
}

class PermissionConsent {
  final bool canPop;
  final bool show;
  final int sdk;

  PermissionConsent({this.canPop = true, this.show = false, required this.sdk});

  PermissionConsent copyWith({bool? canPop, bool? show, int? sdk}) {
    return PermissionConsent(sdk: sdk ?? this.sdk, canPop: canPop ?? this.canPop, show: show ?? this.show);
  }
}
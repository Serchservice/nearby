import 'package:flutter/cupertino.dart';
import 'package:drive/library.dart';
import 'package:smart/smart.dart';

class ConsentWrapper extends StatefulWidget {
  final Widget child;

  const ConsentWrapper({super.key, required this.child});

  @override
  State<ConsentWrapper> createState() => _ConsentWrapperState();
}

class _ConsentWrapperState extends State<ConsentWrapper> {
  final AccessService _accessService = AccessImplementation();

  bool _isPermissionGranted = true;

  @override
  void initState() {
    _initialize();

    super.initState();
  }

  void _initialize() async {
    bool granted = await _accessService.hasLocation();
    setState(() {
      _isPermissionGranted = granted;
    });
  }

  Future<bool> _processPermissionRequest() async {
    bool hasAccess = await _accessService.requestPermissions();
    if(hasAccess) {
      if(PlatformEngine.instance.isMobile || PlatformEngine.instance.isWeb) {
        ActivityLifeCycle.onLocationPermissionGranted();
        return true;
      } else {
        throw SerchException("Unsupported platform", isPlatformNotSupported: true);
      }
    } else {
      return _processPermissionRequest();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConsentLayout(
      cookie: Database.instance.cookie,
      isWeb: PlatformEngine.instance.isWeb,
      onCookieRejected: (CookieConsent cookie) {
        Database.instance.saveCookie(cookie);
        Database.instance.clearAll();
      },
      onCookieAccepted: (CookieConsent cookie) {
        Database.instance.saveCookie(cookie);
      },
      name: "Nearby",
      visitCookiePolicy: (url) => RouteNavigator.openLink(url: url),
      isPermissionGranted: _isPermissionGranted,
      device: PlatformEngine.instance.device,
      requestPermissionAccess: _processPermissionRequest,
      permissionImage: AssetUtility.image(Assets.mapWorld),
      permissions: ["Location", "and others"],
      child: widget.child
    );
  }
}
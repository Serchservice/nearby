import 'dart:async';

import 'package:drive/library.dart';

class CookieConsentController {
  final StreamController<bool> _showConsentController = StreamController.broadcast();
  Stream<bool> get showConsentStream => _showConsentController.stream;

  Cookie _cookie = Cookie.empty();
  Cookie get cookie => _cookie;

  final StreamController<Cookie> _cookieController = StreamController.broadcast();
  Stream<Cookie> get cookieStream => _cookieController.stream;

  bool _showSettings = false;
  bool get showSettings => _showSettings;

  final StreamController<bool> _settingsController = StreamController.broadcast();
  Stream<bool> get settingsStream => _settingsController.stream;

  final RepositoryService _repository = CookieRepository();

  void init() {
    if(PlatformEngine.instance.isWeb) {
      Cookie cookie = _repository.get();

      if(cookie.isAnalyticsGranted && cookie.isAdvertisingGranted && cookie.isEssentialGranted) {
        return;
      } else if(cookie.isEssentialGranted) {
        return;
      } else if(!(cookie.isAnalyticsGranted && cookie.isAdvertisingGranted && cookie.isEssentialGranted)) {
        Database.clear;

        _cookie = Cookie.empty().copyWith(isEssentialGranted: true);
        Future.microtask(() {
          _cookieController.add(_cookie);
          _showConsentController.add(true);
          _settingsController.add(false);
        });
      } else if(!cookie.isRejected) {
        // _cookie = cookie;
        // _showSettings = false;
        //
        // Future.microtask(() {
        //   _cookieController.add(cookie);
        //   _showConsentController.add(true);
        //   _settingsController.add(_showSettings);
        // });
      }
    }
  }

  void toggle() {
    _showSettings = !_showSettings;
    _settingsController.add(_showSettings);
  }

  void reject() {
    _cookie = _cookie.copyWith(isRejected: true);
    _repository.save(_cookie);

    _cookieController.add(cookie);
    _showConsentController.add(false);
  }

  void visitCookiePolicy() => RouteNavigator.openLink(url: "https://www.serchservice.com/hub/legal/cookie-policy");

  void accept() {
    _cookie = _cookie.copyWith(isRejected: false);
    _repository.save(_cookie);

    _cookieController.add(cookie);
    _showConsentController.add(false);
  }

  List<ButtonView> views() {
    Cookie cookie = _repository.get();

    return [
      if(!cookie.isEssentialGranted) ...[
        ButtonView(
          header: "Essential",
          body: "Essential cookies are necessary for features which are essential to your use of our site or services, such as account login, authentication, and site security.",
          index: 0,
          onClick: () {
            _cookie = _cookie.copyWith(isEssentialGranted: true);
            _cookieController.add(_cookie);
          }
        )
      ],
      if(!cookie.isAdvertisingGranted) ...[
        ButtonView(
          header: "Targeted Advertising",
          body: "Targeted advertising cookies allow Serchservice to share your data with advertising partners, including social media companies, to send you more relevant ads on other apps and websites, and for purposes determined by those partners.",
          index: 1,
          onClick: () {
            _cookie = _cookie.copyWith(isAdvertisingGranted: !_cookie.isAdvertisingGranted);
            _cookieController.add(_cookie);
          }
        )
      ],
      if(!cookie.isAnalyticsGranted) ...[
        ButtonView(
          header: "Analytics",
          body: "Analytics cookies allow Serchservice to analyze your visits and actions on our and third-party apps and websites to understand your interests and be able to offer you more relevant ads on other apps and websites.",
          index: 2,
          onClick: () {
            _cookie = _cookie.copyWith(isAnalyticsGranted: !_cookie.isAnalyticsGranted);
            _cookieController.add(_cookie);
          }
        )
      ],
    ];
  }

  bool isSelected(int index, Cookie cookie) {
    if(index == 0) {
      return cookie.isEssentialGranted;
    } else if(index == 1) {
      return cookie.isAdvertisingGranted;
    } else {
      return cookie.isAnalyticsGranted;
    }
  }

  void dispose() {
    _cookieController.close();
    _settingsController.close();
  }
}
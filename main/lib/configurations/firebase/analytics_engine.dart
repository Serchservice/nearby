import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsEngine {
  static final _instance = FirebaseAnalytics.instance;

  static void logOpen() async {
    return _instance.logAppOpen(callOptions: AnalyticsCallOptions(global: true));
  }

  static void logScreen(String route, String layout, {Map<String, dynamic>? parameters}) async {
    return _instance.logScreenView(screenClass: layout, screenName: route, parameters: _convertParameters(parameters));
  }

  static void logEvent(String name, {Map<String, dynamic>? parameters}) async {
    return _instance.logEvent(name: name, parameters: _convertParameters(parameters));
  }

  static void logSelectContent(String type, String id, {Map<String, dynamic>? parameters}) async {
    return _instance.logSelectContent(contentType: type, itemId: id, parameters: _convertParameters(parameters));
  }

  static void serviceSearch(String query) async  {
    return _instance.logSearch(searchTerm: query);
  }

  static void logSearchResults(String query, Map<String, dynamic> parameters) async {
    return _instance.logViewSearchResults(searchTerm: query, parameters: _convertParameters(parameters));
  }

  static Map<String, String> _convertParameters(Map<String, dynamic>? parameters) {
    if (parameters == null) return {};

    return parameters.map((key, value) {
      if (value is String) {
        return MapEntry(key, value);
      } else if (value is int || value is double || value is bool) {
        return MapEntry(key, value.toString());
      } else if (value is List) {
        return MapEntry(key, value.join(', '));
      } else {
        return MapEntry(key, value.toString());
      }
    });
  }
}
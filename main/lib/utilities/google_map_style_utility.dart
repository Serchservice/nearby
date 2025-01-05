import 'dart:convert';

import 'package:flutter/services.dart';

class GoogleMapStyleUtility {
  String mapStyle = "";

  Future<String> style() async {
    String mapStyle = await rootBundle.loadString('asset/common/google_map_style.json');
    return jsonDecode(mapStyle);
  }
}
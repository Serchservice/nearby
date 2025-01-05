import 'dart:convert';

import 'package:drive/library.dart';

class CookieRepository extends RepositoryService<Cookie, String> {
  final DatabaseService _service = DatabaseImplementation(accountDatabase);

  @override
  Future<Optional<Cookie>> delete(Cookie item) async {
    _service.remove("Cookie");
    return Optional<Cookie>.empty();
  }

  @override
  Cookie get() {
    String? data = _service.read("Cookie");

    if(data != null) {
      Map<String, dynamic> jsonData = jsonDecode(data);
      return Cookie.fromJson(jsonData);
    } else {
      return Cookie.empty();
    }
  }

  @override
  Future<Cookie> save(Cookie item) async {
    await _service.write("Cookie", jsonEncode(item.toJson()));
    return item;
  }
}
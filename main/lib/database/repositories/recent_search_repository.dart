import 'dart:convert';

import 'package:drive/library.dart';

class RecentSearchRepository extends RepositoryService<List<SearchShopResponse>, String> {
  final DatabaseService _service = DatabaseImplementation(accountDatabase);

  @override
  Future<Optional<List<SearchShopResponse>>> delete(List<SearchShopResponse> item) async {
    _service.remove("RecentShops");
    return Optional<List<SearchShopResponse>>.empty();
  }

  @override
  List<SearchShopResponse> get() {
    List<dynamic>? data = _service.read("RecentShops");

    if(data != null) {
      return data.map((e) => SearchShopResponse.fromJson(jsonDecode(e))).toList();
    } else {
      return List<SearchShopResponse>.empty();
    }
  }

  @override
  Future<List<SearchShopResponse>> save(List<SearchShopResponse> item) async {
    await _service.write("RecentShops", item.map((e) => jsonEncode(e.toJson())).toList());
    return item;
  }
}
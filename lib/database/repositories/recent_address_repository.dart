import 'dart:convert';

import 'package:drive/library.dart';

class RecentAddressRepository extends RepositoryService<List<Address>, String> {
  final DatabaseService _service = DatabaseImplementation(accountDatabase);

  @override
  Future<Optional<List<Address>>> delete(List<Address> item) async {
    _service.remove("RecentAddress");
    return Optional<List<Address>>.empty();
  }

  @override
  List<Address> get() {
    List<dynamic>? data = _service.read("RecentAddress");

    if(data != null) {
      return data.map((e) => Address.fromJson(jsonDecode(e))).toList();
    } else {
      return List<Address>.empty();
    }
  }

  @override
  Future<List<Address>> save(List<Address> item) async {
    await _service.write("RecentAddress", item.map((e) => jsonEncode(e.toJson())).toList());
    return item;
  }
}
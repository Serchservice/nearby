import 'dart:convert';

import 'package:drive/library.dart';

class AddressRepository extends RepositoryService<Address, String> {
  final DatabaseService _service = DatabaseImplementation(accountDatabase);

  @override
  Future<Optional<Address>> delete(Address item) async {
    _service.remove("Address");
    return Optional<Address>.empty();
  }

  @override
  Address get() {
    String? data = _service.read("Address");

    if(data != null) {
      Map<String, dynamic> jsonData = jsonDecode(data);
      return Address.fromJson(jsonData);
    } else {
      return const Address();
    }
  }

  @override
  Future<Address> save(Address item) async {
    await _service.write("Address", jsonEncode(item.toJson()));
    return item;
  }
}
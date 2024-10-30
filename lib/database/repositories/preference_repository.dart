import 'dart:convert';

import 'package:drive/library.dart';

class PreferenceRepository extends RepositoryService<Preference, String> {
  final DatabaseService _service = DatabaseImplementation(settingsDatabase);

  @override
  Future<Optional<Preference>> delete(Preference item) async {
    _service.remove("Preference");
    return Optional<Preference>.empty();
  }

  @override
  Preference get() {
    String? data = _service.read("Preference");

    if(data != null) {
      Map<String, dynamic> jsonData = jsonDecode(data);
      return Preference.fromJson(jsonData);
    } else {
      return const Preference();
    }
  }

  @override
  Future<Preference> save(Preference item) async {
    await _service.write("Preference", jsonEncode(item.toJson()));
    return item;
  }
}
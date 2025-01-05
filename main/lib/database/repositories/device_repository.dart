import 'dart:convert';

import 'package:drive/library.dart';

class DeviceRepository extends RepositoryService<Device, String> {
  final DatabaseService _service = DatabaseImplementation(settingsDatabase);

  @override
  Future<Optional<Device>> delete(Device item) async {
    _service.remove("Device");
    return Optional<Device>.empty();
  }

  @override
  Device get() {
    String? data = _service.read("Device");

    if(data != null) {
      Map<String, dynamic> jsonData = jsonDecode(data);
      return Device.fromJson(jsonData);
    } else {
      return Device.empty();
    }
  }

  @override
  Future<Device> save(Device item) async {
    await _service.write("Device", jsonEncode(item.toJson()));
    return item;
  }
}
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:drive/library.dart';

/// This class is the wrapper for the local database of the user.
class DatabaseImplementation implements DatabaseService {
  final Box _box;
  DatabaseImplementation(String boxName) : _box = Hive.box(boxName);

  @override
  Future<void> write(String key, dynamic value) async => _box.put(key, value);

  @override
  T? read<T>(String key) => _box.get(key);

  @override
  Future<void> erase() async => _box.clear();

  @override
  Future<void> remove(String key) async => _box.delete(key);
}
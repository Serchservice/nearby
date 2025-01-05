import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// This class is the wrapper for the local database of the user.
///
/// It initializes and opens the local database.

const String accountDatabase = "ACCOUNT_DATABASE";
const String settingsDatabase = "SETTINGS_DATABASE";

class Database {
  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox(settingsDatabase);
    await Hive.openBox(accountDatabase);
  }

  static Future<void> get clear async {
    await DatabaseImplementation(accountDatabase).erase();
    await DatabaseImplementation(settingsDatabase).erase();
  }

  /// DATABASE ACTIONS - PREFERENCE
  static Preference get preference {
    PreferenceRepository db = PreferenceRepository();
    return db.get();
  }

  static ThemeMode get themeMode => preference.theme == ThemeType.light
      ? ThemeMode.light
      : ThemeMode.dark;

  static Future<Preference> savePreference(Preference device) async {
    PreferenceRepository db = PreferenceRepository();
    return db.save(device);
  }

  /// DATABASE ACTIONS - DEVICE
  static Device get device {
    DeviceRepository db = DeviceRepository();
    return db.get();
  }

  static Future<Device> saveDevice(Device device) async {
    DeviceRepository db = DeviceRepository();
    return db.save(device);
  }

  /// DATABASE ACTIONS - ADDRESS
  static Address get address {
    AddressRepository db = AddressRepository();
    return db.get();
  }

  static Future<Address> saveAddress(Address address) async {
    AddressRepository db = AddressRepository();
    return db.save(address);
  }

  /// DATABASE ACTIONS - RECENT ADDRESS
  static List<Address> get recentAddresses {
    RecentAddressRepository db = RecentAddressRepository();
    return db.get();
  }

  static Future<List<Address>> saveRecentAddress(List<Address> address) async {
    RecentAddressRepository db = RecentAddressRepository();
    return db.save(address);
  }

  /// DATABASE ACTIONS - RECENT SEARCH
  static List<SearchShopResponse> get recentSearch {
    RecentSearchRepository db = RecentSearchRepository();
    return db.get();
  }

  static Future<List<SearchShopResponse>> saveRecentSearch(List<SearchShopResponse> address) async {
    RecentSearchRepository db = RecentSearchRepository();
    return db.save(address);
  }
}
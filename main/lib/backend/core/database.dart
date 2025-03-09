import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:sedat/sedat.dart';
import 'package:smart/smart.dart';

/// A singleton class that serves as a wrapper for the local database.
///
/// It initializes and manages repositories for various data models,
/// including user preferences, cookies, devices, addresses, and search history.
class Database extends AbstractSecureDatabaseConfigurer {
  // Private constructor to enforce singleton pattern.
  Database._() {
    canDestroySavedData = false;
    deviceName = "695744cf6ca88f7be9a824df8dca16e7";
    platform = PlatformEngine.instance.platform.toUpperCase();
  }

  /// The singleton instance of [Database].
  static final Database instance = Database._();

  // Repositories for managing different types of stored data.
  final CookieConsentRepository _cookieConsentRepository = CookieConsentRepository();
  final PreferenceRepository _preferenceRepository = PreferenceRepository();
  final DeviceRepository _deviceRepository = DeviceRepository();
  final AddressRepository _addressRepository = AddressRepository();
  final RecentAddressRepository _recentAddressRepository = RecentAddressRepository();
  final RecentSearchRepository _recentSearchRepository = RecentSearchRepository();
  final GoAuthRepository _goAuthRepository = GoAuthRepository();
  final GoAccountRepository _goAccountRepository = GoAccountRepository();
  final GoInterestRepository _goInterestRepository = GoInterestRepository();
  final GoInterestCategoryRepository _goInterestCategoryRepository = GoInterestCategoryRepository();
  final GoPreferenceRepository _goPreferenceRepository = GoPreferenceRepository();

  @override
  String get prefix => "nearby";

  @override
  List<Repository> repositories() {
    return [
      _cookieConsentRepository,
      _preferenceRepository,
      _deviceRepository,
      _addressRepository,
      _recentAddressRepository,
      _recentSearchRepository,
      _goAuthRepository,
      _goAccountRepository,
      _goInterestRepository,
      _goInterestCategoryRepository,
      _goPreferenceRepository
    ];
  }

  /// Retrieves the user preference settings.
  Preference get preference => _preferenceRepository.get();

  /// Retrieves the user go preference settings.
  GoPreference get goPreference => _goPreferenceRepository.get();

  /// Retrieves the stored device information.
  Device get device => _deviceRepository.get();

  /// Retrieves the stored cookie information.
  CookieConsent get cookie => _cookieConsentRepository.get();

  /// Retrieves the stored auth information.
  GoAuthResponse get auth => _goAuthRepository.get();

  /// Retrieves the stored account information.
  GoAccount get account => _goAccountRepository.get();

  /// Retrieves the last used address.
  Address get address => _addressRepository.get();

  /// Retrieves the list of recently used addresses.
  List<Address> get recentAddresses {
    saveRecentAddress([Address.empty(), Address.empty()]);
    return _recentAddressRepository.get();
  }

  /// Retrieves the list of recent search results.
  List<SearchShopResponse> get recentSearch => _recentSearchRepository.get();

  /// Retrieves the list of interests.
  List<GoInterest> get interests => _goInterestRepository.get();

  /// Retrieves the list of interest categories.
  List<GoInterestCategory> get interestCategories => _goInterestCategoryRepository.get();

  /// **Retrieves the user’s preferred theme mode.**
  ///
  /// Returns:
  /// - `ThemeMode.light` if the user prefers a light theme.
  /// - `ThemeMode.dark` if the user prefers a dark theme.
  ThemeMode get themeMode => preference.theme == ThemeType.light ? ThemeMode.light : ThemeMode.dark;

  /// **Retrieves the user’s preferred theme type.**
  ///
  /// Returns:
  /// - `ThemeType.light` if the user prefers a light theme.
  /// - `ThemeType.dark` if the user prefers a dark theme.
  ThemeType get theme => preference.theme;

  /// Indicates whether the current theme mode is dark.
  ///
  /// Returns `true` if the [themeMode] is [ThemeMode.dark], and `false` otherwise.
  bool get isDarkTheme => themeMode == ThemeMode.dark;

  /// Indicates whether the current theme mode is light.
  ///
  /// Returns `true` if the [themeMode] is [ThemeMode.light], and `false` otherwise.
  bool get isLightTheme => themeMode == ThemeMode.light;

  /// Saves the updated user auth settings.
  ///
  /// Returns a [Future] containing the saved [GoAuthResponse] object.
  Future<GoAuthResponse> saveAuth(GoAuthResponse auth) => _goAuthRepository.save(auth);

  /// Saves the updated user account settings.
  ///
  /// Returns a [Future] containing the saved [GoAccount] object.
  Future<GoAccount> saveAccount(GoAccount account) => _goAccountRepository.save(account);

  /// Saves the updated user preference settings.
  ///
  /// Returns a [Future] containing the saved [Preference] object.
  Future<Preference> savePreference(Preference preference) => _preferenceRepository.save(preference);

  /// Saves the updated user go preference settings.
  ///
  /// Returns a [Future] containing the saved [GoPreference] object.
  Future<GoPreference> saveGoPreference(GoPreference preference) => _goPreferenceRepository.save(preference);

  /// Saves the device information.
  ///
  /// Returns a [Future] containing the saved [Device] object.
  Future<Device> saveDevice(Device device) => _deviceRepository.save(device);

  /// Saves the cookie information.
  ///
  /// Returns a [Future] containing the saved [CookieConsent] object.
  Future<CookieConsent> saveCookie(CookieConsent cookie) => _cookieConsentRepository.save(cookie);

  /// Saves the last used address.
  ///
  /// Returns a [Future] containing the saved [Address] object.
  Future<Address> saveAddress(Address address) => _addressRepository.save(address);

  /// Saves the list of recently used addresses.
  ///
  /// Returns a [Future] containing the saved list of [Address] objects.
  Future<List<Address>> saveRecentAddress(List<Address> addresses) => _recentAddressRepository.save(addresses);

  /// Saves the list of recent search results.
  ///
  /// Returns a [Future] containing the saved list of [SearchShopResponse] objects.
  Future<List<SearchShopResponse>> saveRecentSearch(List<SearchShopResponse> searches) => _recentSearchRepository.save(searches);

  /// Saves the list of interests.
  ///
  /// Returns a [Future] containing the saved list of [GoInterest] objects.
  Future<List<GoInterest>> saveInterests(List<GoInterest> interests) => _goInterestRepository.save(interests);

  /// Saves the list of interest categories.
  ///
  /// Returns a [Future] containing the saved list of [GoInterestCategory] objects.
  Future<List<GoInterestCategory>> saveInterestCategories(List<GoInterestCategory> categories) => _goInterestCategoryRepository.save(categories);
}

import 'package:drive/library.dart';
import 'package:sedat/sedat.dart';
import 'package:smart/smart.dart' show JsonMap, JsonMapCollection;

class PreferenceRepository extends JsonRepository<Preference> {
  PreferenceRepository() : super("preference") {
    registerDefault(Preference());
    registerEncoder((item) => item.toJson());
    registerDecoder(Preference.fromJson);
  }
}

class RecentAddressRepository extends CollectionRepository<List<Address>> {
  RecentAddressRepository() : super("recent-address-history") {
    registerDefault(List<Address>.empty());
    registerEncoder((item) {
      return item.map((Address e) => e.toJson()).toList();
    });
    registerDecoder((JsonMapCollection data) {
      return data.map((JsonMap e) => Address.fromJson(e)).toList();
    });
  }
}

class RecentSearchRepository extends CollectionRepository<List<SearchShopResponse>> {
  RecentSearchRepository() : super("recent-search-history") {
    registerDefault(List<SearchShopResponse>.empty());
    registerEncoder((item) {
      return item.map((SearchShopResponse e) => e.toJson()).toList();
    });
    registerDecoder((JsonMapCollection data) {
      return data.map((JsonMap e) => SearchShopResponse.fromJson(e)).toList();
    });
  }
}
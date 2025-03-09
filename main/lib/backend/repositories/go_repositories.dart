import 'package:drive/library.dart';
import 'package:sedat/sedat.dart';
import 'package:smart/smart.dart' show JsonMap, JsonMapCollection;

class GoAccountRepository extends JsonRepository<GoAccount> {
  GoAccountRepository() : super("go-account") {
    registerDefault(GoAccount.empty());
    registerEncoder((item) => item.toJson());
    registerDecoder(GoAccount.fromJson);
  }
}

class GoPreferenceRepository extends JsonRepository<GoPreference> {
  GoPreferenceRepository() : super("go-preference") {
    registerDefault(GoPreference());
    registerEncoder((item) => item.toJson());
    registerDecoder(GoPreference.fromJson);
  }
}

class GoAuthRepository extends JsonRepository<GoAuthResponse> {
  GoAuthRepository() : super("go-auth") {
    registerDefault(GoAuthResponse.empty());
    registerEncoder((item) => item.toJson());
    registerDecoder(GoAuthResponse.fromJson);
  }
}

class GoInterestUpdateRepository extends JsonRepository<GoInterestUpdate> {
  GoInterestUpdateRepository() : super("go-interest-updates") {
    registerDefault(GoInterestUpdate(taken: [], reserved: []));
    registerEncoder((item) => item.toJson());
    registerDecoder(GoInterestUpdate.fromJson);
  }
}

class GoInterestCategoryRepository extends CollectionRepository<List<GoInterestCategory>> {
  GoInterestCategoryRepository() : super("go-interest-categories") {
    registerDefault(List<GoInterestCategory>.empty());
    registerEncoder((item) {
      return item.map((GoInterestCategory e) => e.toJson()).toList();
    });
    registerDecoder((JsonMapCollection data) {
      return data.map((JsonMap e) => GoInterestCategory.fromJson(e)).toList();
    });
  }
}

class GoInterestRepository extends CollectionRepository<List<GoInterest>> {
  GoInterestRepository() : super("go-interests") {
    registerDefault(List<GoInterest>.empty());
    registerEncoder((item) {
      return item.map((GoInterest e) => e.toJson()).toList();
    });
    registerDecoder((JsonMapCollection data) {
      return data.map((JsonMap e) => GoInterest.fromJson(e)).toList();
    });
  }
}
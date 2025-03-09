import 'package:drive/library.dart';
import 'package:sedat/sedat.dart';
import 'package:smart/smart.dart' show CookieConsent, Device;

class AddressRepository extends JsonRepository<Address> {
  AddressRepository() : super("address") {
    registerDefault(Address.empty());
    registerEncoder((item) => item.toJson());
    registerDecoder(Address.fromJson);
  }
}

class CookieConsentRepository extends JsonRepository<CookieConsent> {
  CookieConsentRepository() : super("cookie-consent") {
    registerDefault(CookieConsent.empty());
    registerEncoder((item) => item.toJson());
    registerDecoder(CookieConsent.fromJson);
  }
}

class DeviceRepository extends JsonRepository<Device> {
  DeviceRepository() : super("device") {
    registerDefault(Device.empty());
    registerEncoder((item) => item.toJson());
    registerDecoder(Device.fromJson);
  }
}
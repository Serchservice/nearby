import 'package:drive/library.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';

class ParentController extends GetxController {
  ParentController();
  final state = ParentState();
  // static final ParentController data = Get.find<ParentController>();

  final AppService _appService = AppImplementation();
  final AccessService _accessService = AccessImplementation();
  final OneSignalService _oneSignalService = OneSignalImplementation();

  late AppLifecycleReactor _appLifecycleReactor;

  final InAppReview inAppReview = InAppReview.instance;

  @override
  void onInit() {
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
    _oneSignalService.initialize();

    _checkAccess();

    super.onInit();
  }

  void _checkAccess() {
    _appService.buildDeviceInformation(onSuccess: (device) async {
      Database.saveDevice(device);
      if(!await _accessService.hasLocation()) {
        PermissionSheet.open(sdk: device.sdk);
      }

      AnalyticsEngine.logEvent("DEVICE_INFORMATION", parameters: device.toJson());
    });
  }

  @override
  void onReady() {
    _appService.checkUpdate();
    _appService.registerDevice();

    super.onReady();
  }

  void selectRoute(int index) {
    state.routeIndex.value = index;
    update();
  }
}
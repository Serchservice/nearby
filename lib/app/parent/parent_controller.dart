import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ParentController extends GetxController {
  ParentController();
  final state = ParentState();
  static final ParentController data = Get.find<ParentController>();

  final AppService _appService = AppImplementation();
  final AccessService _accessService = AccessImplementation();
  final OneSignalService _oneSignalService = OneSignalImplementation();
  final ConnectService _connect = Connect();

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
    _appService.verifyDevice();
    _appService.checkUpdate();
    _appService.registerDevice();
    _fetchPackageDetails();

    super.onReady();
  }

  void _fetchPackageDetails() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    state.appName.value = packageInfo.appName;
    state.appPackage.value = packageInfo.packageName;
    state.appVersion.value = packageInfo.version;
    state.appBuildNumber.value = packageInfo.buildNumber;
  }

  void updateTheme(ThemeType theme) {
    if(theme == ThemeType.light) {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
    }

    Preference preference = Database.preference.copyWith(theme: theme);
    state.theme.value = theme;
    Database.savePreference(preference);
  }

  void appStoreReview() async {
    bool isAvailable = await inAppReview.isAvailable();
    if(isAvailable) {
      await inAppReview.requestReview();
    } else {
      notify.tip(message: "Unable to use in-app rating at the moment. Try again later");
    }
  }

  void openLegal() {
    List<ButtonView> options = [
      ButtonView(
        header: "Community Guidelines",
        icon: Icons.people_rounded,
        path: "${Constants.baseWeb}${Constants.communityGuidelines}",
      ),
      ButtonView(
        header: "Non-Discrimination Policy",
        icon: Icons.warning_rounded,
        path: "${Constants.baseWeb}${Constants.nonDiscriminationPolicy}",
      ),
      ButtonView(
        header: "Privacy Policy",
        icon: Icons.privacy_tip_rounded,
        path: "${Constants.baseWeb}${Constants.privacyPolicy}",
      ),
      ButtonView(
        header: "Terms and Condition",
        icon: Icons.confirmation_number_rounded,
        path: "${Constants.baseWeb}${Constants.termsAndConditions}",
      ),
      ButtonView(
        header: "Zero Tolerance Policy",
        icon: Icons.not_interested_rounded,
        path: "${Constants.baseWeb}${Constants.zeroTolerancePolicy}",
      ),
    ];

    Navigate.bottomSheet(
      sheet: AppInformationSheet(
        options: options,
        header: "Legal | Serch",
        onTap: (view) {
          RouteNavigator.openWeb(header: view.header, url: view.path);
        }
      ),
      route: "/centre/app/legal",
      background: Colors.transparent
    );
  }

  List<ButtonView> connect = [
    ButtonView(
      header: "Mail",
      body: "Send us an email when it is your best option.",
      icon: CupertinoIcons.mail_solid,
      path: "account@serchservice.com",
      index: 0
    ),
    ButtonView(
      header: "Call us",
      body: "Get all the help you need with a live assistant.",
      icon: Icons.phone,
      path: "+18445871030",
      index: 1
    ),
  ];

  void selectRoute(int index) {
    state.routeIndex.value = index;
    update();
  }

  bool get canShowButton => state.category.value.type.isNotEmpty
      && state.selectedAddress.value.longitude != 0.0
      && state.selectedAddress.value.latitude != 0.0;

  void selectSection(CategorySection category) {
    state.category.value = category;
  }

  void clearSelection() {
    state.category.value = CategorySection.empty();
    state.selectedAddress.value = Address.empty();
  }

  void updateAddress(Address address) {
    state.selectedAddress.value = address;
  }

  void handleQuickOption(CategorySection section) {
    selectSection(section);
    if(hasAddress) {
      search();
    } else {
      Navigate.to(LocationSearchLayout.route);
    }
  }

  bool get hasAddress => state.selectedAddress.value.longitude != 0.0
      && state.selectedAddress.value.latitude != 0.0
      && state.selectedAddress.value.place.isNotEmpty;

  bool get hasDetails => category() != null || hasAddress;

  Category? category() {
    return Category.categories.firstWhereOrNull((c) {
      return c.sections.any((s) => s.type == state.category.value.type);
    });
  }

  Map<String, List<SearchShopResponse>> groupedShops() {
    Map<String, List<SearchShopResponse>> groupedShops = {};

    for (var shop in state.shopHistory) {
      String category = shop.shop.category;
      groupedShops.putIfAbsent(category, () => []).add(shop);
    }

    return groupedShops;
  }

  Widget selection(BuildContext context) {
    return Obx(() {
      if(hasDetails) {
        return Column(
          children: [
            const SizedBox(height: 20),
            Swiper(
              onRightSwipe: (d) => clearSelection(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  child: InkWell(
                    onTap: () => search(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(hasAddress) ...[
                          Padding(
                            padding: EdgeInsets.all(Sizing.space(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SText(
                                  text: "Your Location",
                                  size: Sizing.font(12),
                                  color: CommonColors.hint
                                ),
                                LocationView(address: state.selectedAddress.value),
                              ],
                            ),
                          ),
                        ],
                        if(hasDetails) ...[
                          Divider(color: Theme.of(context).primaryColorLight)
                        ],
                        if(category() != null) ...[
                          Padding(
                            padding: EdgeInsets.all(Sizing.space(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SText(
                                  text: "Selected category",
                                  size: Sizing.font(12),
                                  color: CommonColors.hint
                                ),
                                SText(
                                  text: category()!.title,
                                  size: Sizing.font(14),
                                  color: Theme.of(context).primaryColor
                                ),
                                SText(
                                  text: state.category.value.title,
                                  size: Sizing.font(12),
                                  color: Theme.of(context).primaryColor
                                ),
                              ],
                            ),
                          ),
                          Divider(color: Theme.of(context).primaryColorLight),
                        ],
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SText(
                                text: "Note (Swipe right to dismiss ${canShowButton ? "or tap to continue" : ""})",
                                size: Sizing.font(12),
                                color: CommonColors.hint
                              ),
                              Spacer(),
                              if(canShowButton) ...[
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: Sizing.space(24),
                                  color: Theme.of(context).primaryColorLight
                                )
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        return Container();
      }
    });
  }

  void search() {
    RequestSearch search = RequestSearch(category: state.category.value, pickup: state.selectedAddress.value);
    _oneSignalService.addSearchTag(state.category.value);
    _oneSignalService.addLocationTag(state.selectedAddress.value);

    Navigate.to(ResultLayout.route, parameters: search.toParams(), arguments: search.toJson());
    clearSelection();
  }

  void updateRecentAddresses(Address address) {
    List<Address> update = List.from(Database.recentAddresses);
    if(!update.any((ad) => (ad.latitude == address.latitude && ad.longitude == address.longitude) || ad.place.toLowerCase() == address.place.toLowerCase())) {
      update.add(address);

      Database.saveRecentAddress(update);
      state.addressHistory.value = update;
    }
  }

  void updateRecentShops(SearchShopResponse shop, ButtonView option) async {
    List<SearchShopResponse> update = List.from(Database.recentSearch);
    if(!update.any((item) => item.shop.id == shop.shop.id)) {
      update.add(shop);

      Database.saveRecentSearch(update);
      state.shopHistory.value = update;
    }

    _connect.post(endpoint: "/nearby/drive", body: {
      "id": shop.shop.id,
      "type": shop.shop.category,
      "provider": shop.isGoogle ? "GOOGLE" : "SERCH",
      "option": option.header
    });
  }
}
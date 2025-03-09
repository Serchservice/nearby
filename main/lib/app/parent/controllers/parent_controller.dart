import 'dart:async';

import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart' show PageController;
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:smart/smart.dart' show TExtensions, IterableExtension;

class ParentController extends GetxController {
  ParentController();
  final state = ParentState();

  static ParentController get data {
    try {
      return Get.find<ParentController>();
    } catch (_) {
      Get.put(ParentController());
      return Get.find<ParentController>();
    }
  }

  final AppService _appService = AppImplementation();
  final LocationService _locationService = LocationImplementation();
  final FirebaseMessagingService _firebaseService = FirebaseMessagingImplementation();
  late AppLifecycleReactor _appLifecycleReactor;

  StreamSubscription? _subscription;
  StreamSubscription? _tokenSubscription;

  final InAppReview inAppReview = InAppReview.instance;
  final PageController pageController = PageController();

  final args = Get.arguments;

  @override
  void onInit() {
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();

    getCurrentLocation();

    super.onInit();
  }

  void getCurrentLocation() {
    state.isGettingCurrentLocation.value = true;

    _locationService.getAddress(onSuccess: (address, position) {
      state.isGettingCurrentLocation.value = false;

      ActivityLifeCycle.onAddressChanged(address);
      state.currentLocation.value = address;
    }, onError: (error) {
      state.isGettingCurrentLocation.value = false;

      notify.error(message: error);
    });
  }

  @override
  void onReady() {
    _appService.checkUpdate();
    _appService.registerDevice();
    _firebaseService.foreground();

    _subscription = CommonUtility.fetch(durationInSeconds: 3600, action: () {
      if(state.isAuthenticated.value) {
        _updateUserLocation();
      }
    });

    _tokenSubscription = CommonUtility.fetch(durationInSeconds: 3600, action: () {
      if(state.isAuthenticated.value) {
        _refreshToken();
      }
    });

    super.onReady();
  }

  void _refreshToken() async {
    ConnectService connect = Connect();

    connect.post(endpoint: "/auth/go/refresh", body: {"token": Database.instance.auth.session}).then((Outcome response) {
      if(response.isSuccessful) {
        GoAuthResponse auth = GoAuthResponse.fromJson(response.data);
        Database.instance.saveAuth(auth);
      } else if(response.isUserNotFound) {
        notify.error(message: response.message);
        ActivityLifeCycle.onSignOut();
        BCapLifeCycle.onSignOut();
      } else {
        notify.error(message: response.message);
      }
    });
  }

  void _updateUserLocation() async {
    _locationService.getAddress(
      onSuccess: (address, position) {
        ActivityLifeCycle.onAddressChanged(address);
        BCapLifeCycle.onAddressChanged(address);
      },
      onError: (error) {}
    );
  }

  void selectRoute(int index) {
    state.routeIndex.value = index;
    pageController.jumpToPage(index);
    update();
  }

  void changeRoute(int index) {
    state.routeIndex.value = index;
    update();
  }

  bool get hasCurrentLocation => state.currentLocation.value.hasAddress;

  bool get canUseCurrentLocation => state.useCurrentLocation.value && hasCurrentLocation;

  bool get showSwitch => state.isGettingCurrentLocation.isFalse && hasCurrentLocation;

  bool get hasSelectedLocation => state.selectedAddress.value.hasAddress;

  bool get hasLocation => hasSelectedLocation || canUseCurrentLocation;

  bool get hasCategory => state.category.value.type.isNotEmpty;

  bool get canShowButton => hasCategory && hasSelectedLocation;

  bool get hasDetails => (category.isNotNull && category!.title.isNotEmpty && hasCategory) || hasSelectedLocation;

  String get avatar => state.account.value.avatar.isEmpty ? state.auth.value.image : state.account.value.avatar;

  String get name => state.account.value.fullName.isEmpty ? state.auth.value.fullName : state.account.value.fullName;

  String get initials => state.account.value.initials.isEmpty ? state.auth.value.initials : state.account.value.initials;

  Category? get category {
    return Category.categories.find((c) {
      return c.sections.any((s) => s.type == state.category.value.type);
    });
  }

  void handleLocationSearch({Function(Address address)? onReceived}) async {
    dynamic result = await LocationSearchLayout.to();
    if(result != null && result is Address) {
      _updateAddress(result);

      if(onReceived.isNotNull) {
        onReceived!(result);

        return;
      }

      if(hasCategory) {
        search();
      }
    }
  }

  void _updateAddress(Address address) {
    state.selectedAddress.value = address;
  }

  void search() {
    Address pickup = canUseCurrentLocation ? state.currentLocation.value : state.selectedAddress.value;

    RequestSearch search = RequestSearch(category: state.category.value, pickup: pickup);

    Navigate.to(ResultLayout.route, parameters: search.toParams(), arguments: search.toJson());
    clearSelection();
  }

  void clearSelection() {
    state.category.value = CategorySection.empty();
    state.selectedAddress.value = Address.empty();
  }

  void handleCategorySearch(CategorySection selected, {Function(CategorySection section)? onReceived}) async {
    dynamic result = await CategorySearchLayout.to(section: selected);
    if(result != null && result is CategorySection) {
      _selectSection(result);

      if(onReceived.isNotNull) {
        onReceived!(result);

        return;
      }

      if(hasLocation) {
        search();
      }
    }
  }

  void _selectSection(CategorySection category) {
    state.category.value = category;
  }

  void handleQuickOption(CategorySection section) {
    _selectSection(section);

    if(hasLocation) {
      search();
    } else {
      handleLocationSearch();
    }
  }

  void onCurrentLocationChanged(bool value) {
    Database.instance.savePreference(Database.instance.preference.copyWith(useCurrentLocation: value));

    state.useCurrentLocation.value = value;

    if(hasCategory && value) {
      search();
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _tokenSubscription?.cancel();

    super.onClose();
  }

  void resetPage(int index) {
    state.routeIndex.value = index;
    pageController.jumpToPage(index);
    update();

    Navigate.close();
  }
}
import 'package:drive/library.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:get/get.dart';
import 'package:flutter/material.dart' show CarouselController, ScrollPosition, ScrollController;
import 'package:smart/smart.dart';

import 'go_activity_viewer_state.dart';

class GoActivityViewerController extends GetxController {
  GoActivityViewerController();
  final state = GoActivityViewerState();

  final ConnectService _connect = Connect();
  final LocationService _locationService = LocationImplementation();

  EasyNavigation<GoActivity>? navigate;

  final CarouselController carouselController = CarouselController(initialItem: 0);
  final ScrollController scrollController = ScrollController();

  Map<String, String?> params = Get.parameters;
  dynamic args = Get.arguments;

  GoActivityUpdated? onUpdate;

  @override
  void onInit() {
    if(args != null && Instance.of<GoActivity>(args["activity"])) {
      _setup(args["activity"]);
    } else {
      state.isLoading.value = false;
    }

    if(args != null && Instance.of<GoActivityUpdated>(args["on_updated"])) {
      onUpdate = args["on_updated"];
    }

    state.appbarHeight.value = maxHeight;

    super.onInit();
  }

  void _setup(GoActivity activity) {
    List<GoUser> attendingUsers = List.from(activity.attendingUsers);

    if(activity.user.isNotNull) {
      attendingUsers.add(activity.user!);
    }

    state.activity.value = activity;
    state.attendingUsers.value = attendingUsers;
    state.totalImageCount.value = images.length;

    navigate = EasyNavigation(
      response: activity,
      showDetails: false,
      pickupLocation: state.currentLocation.value
    );
  }

  @override
  void onReady() {
    _getCurrentLocation();

    if(params.containsKey("id") && params["id"].isNotNull) {
      if(state.activity.value.hasActivity) {
        state.isLoading.value = false;
      } else {
        _fetchActivity(params["id"]!);
      }
    }

    carouselController.addListener(_carouselListener);
    scrollController.addListener(_scrollListener);

    super.onReady();
  }

  void _getCurrentLocation() {
    if(state.currentLocation.value.hasAddress.isFalse) {
      state.isGettingCurrentLocation.value = true;
    }

    _locationService.getAddress(onSuccess: (address, position) {
      state.isGettingCurrentLocation.value = false;

      ActivityLifeCycle.onAddressChanged(address);
      state.currentLocation.value = address;
    }, onError: (error) {
      state.isGettingCurrentLocation.value = false;

      if(state.currentLocation.value.hasAddress.isFalse) {
        notify.error(message: error);
      }
    });
  }

  void _fetchActivity(String id) async {
    state.isLoading.value = true;
    if(state.currentLocation.value.hasAddress.isFalse) {
      return _fetchActivity(id);
    } else {
      String params = "?lat=${state.currentLocation.value.latitude}&lng=${state.currentLocation.value.longitude}";

      Outcome response = await _connect.get(endpoint: "/go/activity/$id$params");
      if(response.isSuccessful) {
        state.isLoading.value = false;

        GoActivity activity = GoActivity.fromJson(response.data);
        state.activity.value = activity;
        // onUpdated(activity);
      } else {
        notify.error(message: response.message);
      }
    }
  }

  void _carouselListener() {
    if(carouselController.hasClients.isFalse) {
      return;
    }

    ScrollPosition position = carouselController.position;
    double width = Get.width - 32;
    if (position.hasPixels) {
      state.currentImageIndex.value = (position.pixels / width).round();
    }
  }

  void _scrollListener() {
    if(scrollController.hasClients.isFalse) {
      return;
    }

    ScrollPosition position = scrollController.position;
    int level = 5;

    // Adjust height dynamically based on scroll direction
    if (position.userScrollDirection == ScrollDirection.reverse) {
      // Scrolling **up** (minimize height)
      if (state.appbarHeight.value.isGt(minHeight)) {
        state.appbarHeight.value = (state.appbarHeight.value - level).clamp(minHeight, maxHeight);
      }
    } else if (position.userScrollDirection == ScrollDirection.forward) {
      // Scrolling **down** (increase height)
      if (state.appbarHeight.value.isLt(maxHeight)) {
        state.appbarHeight.value = (state.appbarHeight.value + level).clamp(minHeight, maxHeight);
      }
    }
  }

  bool get showLoading => state.isLoading.value || state.isGettingCurrentLocation.value;

  List<GoFile> get images => state.activity.value.images;

  List<SelectedMedia> get resources => images.map((GoFile image) => SelectedMedia(path: image.file)).toList();

  List<String> get attendingUserAvatars => state.attendingUsers.value.map((GoUser user) => user.avatar).toList();

  List<String> get emptyAttendingAvatars => List.generate(6, (index) => "");

  bool get showMap => state.activity.value.location.isNotNull && state.activity.value.location!.hasAddress && Database.instance.address.hasAddress;

  double get maxHeight => 500;

  double get minHeight => 50;

  GoActivityUpdated get onUpdated => onUpdate ?? (GoActivity activity) {};

  bool get showNotify => state.activity.value.isClosed.isFalse && state.activity.value.hasResponded.isFalse && state.activity.value.isCreatedByCurrentUser.isFalse;

  @override
  void onClose() {
    carouselController.removeListener(_carouselListener);
    scrollController.removeListener(_scrollListener);

    carouselController.dispose();
    scrollController.dispose();

    super.onClose();
  }
}
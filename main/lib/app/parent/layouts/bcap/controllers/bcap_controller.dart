import 'dart:async';

import 'package:flutter/material.dart' show Icons;
import 'package:get/get.dart';
import 'package:drive/library.dart';
import 'package:smart/ui.dart' show PagedController;
import 'package:smart/smart.dart' show ButtonView, IntExtensions, IterableExtension, TExtensions;

import '../widgets/bcap_filter_sheet.dart';
import '../widgets/bcap_preference_sheet.dart';
import 'bcap_state.dart';

class BCapController extends GetxController {
  BCapController();
  static BCapController get data {
    try {
      return Get.find<BCapController>();
    } catch (_) {
      Get.put(BCapController());
      return Get.find<BCapController>();
    }
  }

  final state = BCapState();

  final ConnectService _connect = Connect();

  final PagedController<int, GoBCap> bcapController = PagedController(firstPageKey: 0);

  final StreamController<GoAuthResponse> authController = StreamController<GoAuthResponse>.broadcast();
  Stream<GoAuthResponse> get authStream => authController.stream;

  final StreamController<Address> locationController = StreamController<Address>.broadcast();
  Stream<Address> get locationStream => locationController.stream;

  List<ButtonView> actions(bool isAuthenticated) => [
    ButtonView(
      icon: Icons.control_point_duplicate_rounded,
      header: "Preferences",
      onClick: BCapPreferenceSheet.open
    ),
    if(isAuthenticated) ...[
      if(CentreController.data.state.interests.isNotEmpty) ...[
        ButtonView(
          icon: Icons.filter_list_rounded,
          header: "Filter",
          onClick: () => BCapFilterSheet.open(
            onInterestSelected: onInterestSelected,
            selected: state.filter.value,
            interests: CentreController.data.state.interests
          )
        )
      ],
    ],
  ];

  void onContinuousLoopingChanged(bool value) {
    state.continuousLooping.value = value;
  }

  GoInterestSelected get onInterestSelected => (interest) {
    state.filter.value = interest;
    Navigate.close();

    bcapController.refresh();
  };

  @override
  void onInit() {
    bcapController.addPageRequestListener((pageKey) {
      _fetchBCaps(pageKey);
    });

    super.onInit();
  }

  void _fetchBCaps(int page) async {
    if(ParentController.data.state.isGettingCurrentLocation.value) {
      return Future.delayed(Duration(milliseconds: 500), () => _fetchBCaps(page));
    }

    double latitude = ParentController.data.hasCurrentLocation
        ? ParentController.data.state.currentLocation.value.latitude
        : Database.instance.address.hasAddress
        ? Database.instance.address.latitude
        : 0.0;

    double longitude = ParentController.data.hasCurrentLocation
        ? ParentController.data.state.currentLocation.value.longitude
        : Database.instance.address.hasAddress
        ? Database.instance.address.longitude
        : 0.0;

    int pageSize = 20;

    String filters = "?page=$page&size=$pageSize&scoped=${false}&lat=$latitude&lng=$longitude";
    if(state.timestamp.value.isNotNull) {
      filters += "&timestamp=${state.timestamp.value!.toIso8601String()}";
    }

    if(state.filter.value.hasInterest) {
      filters += "&interest=${state.filter.value.id}";
    }

    _connect.get(endpoint: "/go/bcap/all$filters").then((Outcome response) {
      if(response.isOk) {
        List<dynamic> result = response.data;
        List<GoBCap> activities = result.map((data) => GoBCap.fromJson(data)).toList();
        final isLastPage = activities.length.isLessThan(pageSize);

        if(isLastPage) {
          bcapController.appendLastPage(activities);
        } else {
          bcapController.appendPage(activities, page + 1);
        }
      } else {
        bcapController.error = response.message;
      }
    });
  }

  GoBCapUpdated get onGoBCapUpdated => (GoBCap activity) {
    List<GoBCap> caps = bcapController.itemList ?? [];
    int index = caps.findIndex((element) => element.id.equals(activity.id));

    if(index.notEquals(-1)) {
      caps[index] = activity;
      bcapController.itemList = caps;
    }
  };

  GoBCapUpdated get onGoBCapDeleted => (GoBCap activity) {
    List<GoBCap> caps = bcapController.itemList ?? [];
    int index = caps.findIndex((element) => element.id.equals(activity.id));

    if(Get.isBottomSheetOpen ?? false) {
      Navigate.close(closeAll: false);
    }

    if(index.notEquals(-1)) {
      caps.removeAt(index);
      bcapController.itemList = caps;
    } else {
      bcapController.refresh();
    }
  };

  @override
  void onReady() {
    authStream.listen((GoAuthResponse activity) {
      ParentController.data.state.auth.value = activity;

      if(activity.isLoggedIn) {
        bcapController.refresh();
      } else {
        bcapController.refresh();
      }
    });

    locationStream.listen((Address activity) {
      _fetchBCaps(0);
    });

    super.onReady();
  }

  @override
  void onClose() {
    bcapController.dispose();
    locationController.close();
    authController.close();

    super.onClose();
  }
}
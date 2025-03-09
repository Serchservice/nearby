import 'dart:async';

import 'package:camera/camera.dart' show availableCameras;
import 'package:drive/library.dart';
import 'package:flutter/cupertino.dart' show AnimationController, CurvedAnimation, Curves, TextEditingController, WidgetsBinding, WidgetsBindingObserver;
import 'package:flutter/material.dart' show Icons;
import 'package:get/get.dart';
import 'package:smart/ui.dart' show PagedController;
import 'package:smart/smart.dart' show ButtonView, DoubleExtensions, IntExtensions, IterableExtension, TExtensions;

import '../views/create/create_activity.dart';
import '../views/location_viewer/location_viewer.dart';
import '../widgets/activity_filter_sheet.dart';
import 'activity_state.dart';

class ActivityController extends GetxController with WidgetsBindingObserver, GetTickerProviderStateMixin {
  ActivityController();
  final state = ActivityState();
  static ActivityController get data {
    try {
      return Get.find<ActivityController>();
    } catch (_) {
      Get.put(ActivityController());
      return Get.find<ActivityController>();
    }
  }

  final AccessService _accessService = AccessImplementation();
  final ConnectService _connect = Connect();

  final StreamController<GoAuthResponse> authController = StreamController<GoAuthResponse>.broadcast();
  Stream<GoAuthResponse> get authStream => authController.stream;

  final StreamController<Address> locationController = StreamController<Address>.broadcast();
  Stream<Address> get locationStream => locationController.stream;

  final StreamController<GoCreate> createController = StreamController<GoCreate>.broadcast();
  Stream<GoCreate> get createStream => createController.stream;

  final StreamController<GoAccount> accountController = StreamController<GoAccount>.broadcast();
  Stream<GoAccount> get accountStream => accountController.stream;

  final TextEditingController searchController = TextEditingController();

  final int _pageSize = 20;

  final PagedController<int, GoActivity> activityController = PagedController(firstPageKey: 0);
  final PagedController<int, GoActivity> upcomingActivityController = PagedController(firstPageKey: 0);
  final PagedController<int, GoActivity> ongoingActivityController = PagedController(firstPageKey: 0);

  late final AnimationController _animationController;
  late final CurvedAnimation animation;

  List<ButtonView> get tabs => [
    ButtonView(header: "All", index: 0, onClick: () => _updateCurrentTab(0)),
    ButtonView(header: "Upcoming", index: 1, onClick: () => _updateCurrentTab(1)),
    ButtonView(header: "Ongoing", index: 2, onClick: () => _updateCurrentTab(2)),
  ];

  void _updateCurrentTab(int index) {
    state.currentTab.value = index;
  }

  List<ButtonView> get actions => [
    if(ParentController.data.hasCurrentLocation) ...[
      ButtonView(
        icon: Icons.location_on_sharp,
        header: "Current Location",
        onClick: LocationViewer.open
      )
    ] else if(ParentController.data.state.isGettingCurrentLocation.value) ...[
      ButtonView(
        icon: Icons.radio_button_on_rounded,
        header: "Current Location",
        onClick: () => notify.tip(message: "Getting current location", color: CommonColors.instance.bluish)
      )
    ],
    if(ParentController.data.state.isAuthenticated.value) ...[
      if(CentreController.data.state.interests.isNotEmpty) ...[
        ButtonView(
          icon: Icons.filter_list_rounded,
          header: "Filter",
          onClick: () => ActivityFilterSheet.open(
            onInterestSelected: onInterestSelected,
            selected: state.filter.value,
            interests: CentreController.data.state.interests
          )
        )
      ],
    ],
    ButtonView(
      icon: Icons.add_rounded,
      header: "Create",
      onClick: () {
        if(ParentController.data.state.isAuthenticated.value) {
          CreateActivity.open();
        } else {
          GoIntro.open();
        }
      }
    ),
  ];

  GoInterestSelected get onInterestSelected => (interest) {
    state.filter.value = interest;
    Navigate.close();

    activityController.refresh();
  };

  @override
  void onInit() {
    if(Database.instance.auth.isLoggedIn) {
      state.hideSearchButton.value = false;

      if(!MainConfiguration.data.isBackground.value) {
        _handlePermissions();
      }
    } else {
      state.hideSearchButton.value = true;
    }

    _initControllers();

    activityController.addPageRequestListener(_fetchActivity);
    upcomingActivityController.addPageRequestListener(_fetchUpcomingActivity);
    ongoingActivityController.addPageRequestListener(_fetchOngoingActivity);

    super.onInit();
  }

  Future<bool> _handlePermissions() async {
    bool hasAccess = await _accessService.checkForStorageOrAskPermission(PlatformEngine.instance.device.sdk);
    if(hasAccess) {
      if(PlatformEngine.instance.isMobile || PlatformEngine.instance.isWeb) {
        try {
          MainConfiguration.data.cameras.value = await availableCameras();
        } catch (_) {}

        return true;
      } else {
        throw SerchException("Unsupported platform", isPlatformNotSupported: true);
      }
    } else {
      return _handlePermissions();
    }
  }

  void _initControllers() {
    WidgetsBinding.instance.addObserver(this);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastEaseInToSlowEaseOut,
    );
  }

  void _fetchActivity(int page) async {
    if(ParentController.data.state.isGettingCurrentLocation.value) {
      return Future.delayed(Duration(milliseconds: 500), () => _fetchActivity(page));
    }

    Outcome response = await _connect.get(endpoint: _endpoint(page));
    if(response.isOk) {
      List<dynamic> result = response.data;
      List<GoActivity> activities = result.map((data) => GoActivity.fromJson(data)).toList();
      final isLastPage = activities.length.isLessThan(_pageSize);

      if(state.search.value.isNotEmpty) {
        _updateCurrentTab(0);
      }

      if(isLastPage) {
        activityController.appendLastPage(activities);
      } else {
        activityController.appendPage(activities, page + 1);
      }

      return;
    } else {
      activityController.error = response.message;
      return;
    }
  }

  String _endpoint(int page) {
    String filters = _buildFilters(page);

    if(state.search.value.isEmpty) {
      filters += "&scoped=${false}";

      if(state.timestamp.value.isNotNull) {
        filters += "&timestamp=${state.timestamp.value!.toIso8601String()}";
      }

      if(state.filter.value.hasInterest) {
        filters += "&interest=${state.filter.value.id}";
      }

      return "/go/activity/all$filters";
    } else {
      filters += "&q=${state.search.value.trim()}";

      return "/go/activity/search$filters";
    }
  }

  bool get hasFilter => state.filter.value.hasInterest || state.timestamp.value.isNotNull;

  PagedController<int, GoActivity> get pagedController => state.currentTab.value.equals(0)
    ? activityController
    : state.currentTab.value.equals(1) ? upcomingActivityController : ongoingActivityController;

  String _buildFilters(int page) {
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

    return "?page=$page&size=$_pageSize&lat=$latitude&lng=$longitude";
  }

  void _fetchUpcomingActivity(int page) async {
    if(ParentController.data.state.isGettingCurrentLocation.value) {
      return Future.delayed(Duration(milliseconds: 500), () => _fetchUpcomingActivity(page));
    }

    Outcome response = await _connect.get(endpoint: "/go/activity/all/upcoming${_buildFilters(page)}");
    if(response.isOk) {
      List<dynamic> result = response.data;
      List<GoActivity> activities = result.map((data) => GoActivity.fromJson(data)).toList();
      final isLastPage = activities.length.isLessThan(_pageSize);

      if(isLastPage) {
        upcomingActivityController.appendLastPage(activities);
      } else {
        upcomingActivityController.appendPage(activities, page + 1);
      }

      return;
    } else {
      upcomingActivityController.error = response.message;
      return;
    }
  }

  void _fetchOngoingActivity(int page) async {
    if(ParentController.data.state.isGettingCurrentLocation.value) {
      return Future.delayed(Duration(milliseconds: 500), () => _fetchUpcomingActivity(page));
    }

    Outcome response = await _connect.get(endpoint: "/go/activity/all/ongoing${_buildFilters(page)}");
    if(response.isOk) {
      List<dynamic> result = response.data;
      List<GoActivity> activities = result.map((data) => GoActivity.fromJson(data)).toList();
      final isLastPage = activities.length.isLessThan(_pageSize);

      if(isLastPage) {
        ongoingActivityController.appendLastPage(activities);
      } else {
        ongoingActivityController.appendPage(activities, page + 1);
      }

      return;
    } else {
      ongoingActivityController.error = response.message;
      return;
    }
  }

  @override
  void onReady() {
    searchController.addListener(() {
      onSearchChanged(searchController.text);
    });

    createStream.listen((GoCreate activity) {
      if(activity.hasData) {
        _processGoCreate(activity);
      }
    });

    MainConfiguration.data.isBackground.listen((bool isBackground) {
      if(isBackground) {
        /// Do nothing
      } else {
        _handlePermissions();
      }
    });

    authStream.listen((GoAuthResponse activity) {
      ParentController.data.state.auth.value = activity;
      console.log(activity.toJson());

      if(activity.isLoggedIn) {
        ParentController.data.state.isAuthenticated.value = true;
        Database.instance.saveAuth(activity);

        if(!MainConfiguration.data.isBackground.value) {
          _handlePermissions();
        }

        activityController.refresh();
        ongoingActivityController.refresh();
        upcomingActivityController.refresh();
        CentreController.data.load();
      } else {
        ParentController.data.resetPage(0);
        ParentController.data.state.isAuthenticated.value = false;
        Database.instance.saveAuth(GoAuthResponse.empty());

        activityController.refresh();
        ongoingActivityController.refresh();
        upcomingActivityController.refresh();
      }
    });

    accountStream.listen((GoAccount activity) {
      Database.instance.saveAccount(activity);
      ParentController.data.state.account.value = activity;
    });

    locationStream.listen((Address activity) {
      Database.instance.saveAddress(activity);

      if(ParentController.data.state.isAuthenticated.value) {
        GoAccount account = Database.instance.account;
        account = account.copyWith(location: activity);

        ActivityLifeCycle.onAccountReceived(account, true);
      }
    });

    super.onReady();
  }

  void onGoCreateUploadRetry(GoCreateUpload upload) {
    upload = upload.copyWith(hasError: false, isLoading: true);
    List<GoCreateUpload> uploads = List.from(state.uploads);

    if(uploads.any((GoCreateUpload element) => element.id.equals(upload.id))) {
      uploads[uploads.indexWhere((GoCreateUpload element) => element.id.equals(upload.id))] = upload;
      state.uploads.value = uploads;
    }

    _processGoCreateUpload(upload);
  }

  void onGoCreateUploadDismiss(GoCreateUpload upload) {
    List<GoCreateUpload> uploads = List.from(state.uploads);
    uploads.removeWhere((GoCreateUpload element) => element.id.equals(upload.id));
    state.uploads.value = uploads;
  }

  void _processGoCreate(GoCreate create) async {
    int id = state.uploads.length + 1;
    GoCreateUpload upload = GoCreateUpload(id: id, isLoading: true, create: create);

    List<GoCreateUpload> uploads = List.from(state.uploads);
    uploads.add(upload);
    state.uploads.value = uploads;

    if(create.location.isNotNull) {
      CentreController.data.updateRecentAddresses(create.location!);
    }

    _processGoCreateUpload(upload);
  }

  void _processGoCreateUpload(GoCreateUpload upload) {
    _connect.post(endpoint: "/go/activity/create", body: upload.create.toJson()).then((Outcome response) {
      List<GoCreateUpload> uploads = List.from(state.uploads);

      if(response.isSuccessful) {
        if(uploads.any((GoCreateUpload element) => element.id.equals(upload.id))) {
          uploads.removeWhere((GoCreateUpload element) => element.id.equals(upload.id));
          state.uploads.value = uploads;
        }

        GoActivity activity = GoActivity.fromJson(response.data);
        activityController.itemList = [activity, ...activityController.itemList ?? []];
        CentreController.data.updateActivityList(activity);
      } else {
        upload = upload.copyWith(hasError: true, isLoading: false);

        if(uploads.any((GoCreateUpload element) => element.id.equals(upload.id))) {
          uploads[uploads.indexWhere((GoCreateUpload element) => element.id.equals(upload.id))] = upload;
          state.uploads.value = uploads;
        }

        notify.tip(message: response.message, color: CommonColors.instance.error);
      }
    });
  }

  void onSearchSubmitted(String value) {
    if(value.isNotEmpty) {
      state.search.value = value;
      activityController.refresh();
    }
  }

  void onSearchChanged(String value) {
    if(value.isNotEmpty) {
      state.search.value = value;
      activityController.refresh();
    }
  }

  void onSearchCleared() {
    searchController.clear();
    state.search.value = "";

    activityController.refresh();
  }

  void onSearchPressed() {
    if (_animationController.value.equals(1)) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    state.hideSearchButton.value = !state.hideSearchButton.value;
  }

  GoActivityUpdated get onGoActivityUpdated => (GoActivity activity) {
    List<GoActivity> activities = activityController.itemList ?? [];
    int index = activities.findIndex((element) => element.id.equals(activity.id));

    if(index.notEquals(-1)) {
      activities[index] = activity;
      activityController.itemList = activities;
    } else {
      activities = upcomingActivityController.itemList ?? [];
      index = activities.findIndex((element) => element.id.equals(activity.id));

      if(index.notEquals(-1)) {
        activities[index] = activity;
        upcomingActivityController.itemList = activities;
      } else {
        activities = ongoingActivityController.itemList ?? [];
        index = activities.findIndex((element) => element.id.equals(activity.id));

        if(index.notEquals(-1)) {
          activities[index] = activity;
          ongoingActivityController.itemList = activities;
        }
      }
    }
  };

  GoActivityUpdated get onGoActivityDeleted => (GoActivity activity) {
    List<GoActivity> activities = activityController.itemList ?? [];
    int index = activities.findIndex((element) => element.id.equals(activity.id));

    if(Get.isBottomSheetOpen ?? false) {
      Navigate.close(closeAll: false);
    }

    if(index.notEquals(-1)) {
      activities.removeAt(index);
      activityController.itemList = activities;
    } else {
      activities = upcomingActivityController.itemList ?? [];
      index = activities.findIndex((element) => element.id.equals(activity.id));

      if(index.notEquals(-1)) {
        activities.removeAt(index);
        upcomingActivityController.itemList = activities;
      } else {
        activities = ongoingActivityController.itemList ?? [];
        index = activities.findIndex((element) => element.id.equals(activity.id));

        if(index.notEquals(-1)) {
          activities.removeAt(index);
          ongoingActivityController.itemList = activities;
        } else {
          activityController.refresh();

          if(activity.isPending) {
            upcomingActivityController.refresh();
          } else if(activity.isOngoing) {
            ongoingActivityController.refresh();
          }
        }
      }
    }
  };

  void updateActivity(String bCap, String id) {
    List<GoActivity> activities = [
      ...activityController.itemList ?? [],
      ...upcomingActivityController.itemList ?? [],
      ...ongoingActivityController.itemList ?? []
    ];

    GoActivity? activity = activities.find((element) => element.id.equals(id));
    if(activity.isNotNull) {
      activity = activity!.copyWith(bcap: bCap);
      onGoActivityUpdated(activity);
    }
  }

  @override
  void onClose() {
    authController.close();
    createController.close();
    locationController.close();
    accountController.close();

    searchController.dispose();
    activityController.dispose();
    upcomingActivityController.dispose();
    ongoingActivityController.dispose();

    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    animation.dispose();

    super.onClose();
  }
}
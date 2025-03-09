import 'dart:async';

import 'package:flutter/material.dart' show Icons;
import 'package:get/get.dart';
import 'package:smart/smart.dart';
import 'package:drive/library.dart';

import 'centre_state.dart';

class CentreController extends GetxController {
  CentreController();
  final state = CentreState();
  static CentreController get data {
    try {
      return Get.find<CentreController>();
    } catch (_) {
      Get.put(CentreController());
      return Get.find<CentreController>();
    }
  }

  final ConnectService _connect = Connect();

  final int _pageSize = 20;

  final PagedController<int, GoActivity> activityController = PagedController(firstPageKey: 0);
  final PagedController<int, GoActivity> upcomingActivityController = PagedController(firstPageKey: 0);
  final PagedController<int, GoActivity> ongoingActivityController = PagedController(firstPageKey: 0);
  final PagedController<int, GoBCap> bcapController = PagedController(firstPageKey: 0);

  final StreamController<GoBCapCreate> createController = StreamController<GoBCapCreate>.broadcast();
  Stream<GoBCapCreate> get createStream => createController.stream;

  List<ButtonView> tabs = [
    ButtonView(header: "Activities", icon: Icons.attractions, index: 0),
    ButtonView(header: "Upcoming Activities", icon: Icons.upcoming_rounded, index: 1),
    ButtonView(header: "Ongoing Activities", icon: Icons.edit_attributes_rounded, index: 2),
    ButtonView(header: "BCaps", image: Assets.logoFavicon, index: 3),
  ];

  void change(int index) {
    state.current.value = index;
  }

  PagedController<int, dynamic> get pagedController => state.current.value.equals(0)
      ? activityController
      : state.current.value.equals(1)
      ? upcomingActivityController
      : state.current.value.equals(2)
      ? ongoingActivityController
      : bcapController;

  @override
  void onInit() {
    activityController.addPageRequestListener(_fetchActivities);
    upcomingActivityController.addPageRequestListener(_fetchUpcomingActivities);
    ongoingActivityController.addPageRequestListener(_fetchOngoingActivities);

    bcapController.addPageRequestListener(_fetchBCaps);

    super.onInit();
  }

  void _fetchActivities(int page) async {
    if(ParentController.data.state.isGettingCurrentLocation.value) {
      return Future.delayed(Duration(milliseconds: 500), () => _fetchActivities(page));
    }

    _connect.get(endpoint: "/go/activity/all${_buildFilters(page)}").then((Outcome response) {
      if(response.isOk) {
        List<dynamic> result = response.data;
        List<GoActivity> activities = result.map((data) => GoActivity.fromJson(data)).toList();
        final isLastPage = activities.length.isLessThan(_pageSize);

        if(isLastPage) {
          activityController.appendLastPage(activities);
        } else {
          activityController.appendPage(activities, page + 1);
        }
      } else {
        activityController.error = response.message;
      }
    });
  }

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

    return "?page=$page&size=$_pageSize&lat=$latitude&lng=$longitude&scoped=${true}";
  }

  void _fetchUpcomingActivities(int page) async {
    if(ParentController.data.state.isGettingCurrentLocation.value) {
      return Future.delayed(Duration(milliseconds: 500), () => _fetchUpcomingActivities(page));
    }

    _connect.get(endpoint: "/go/activity/all/upcoming${_buildFilters(page)}").then((Outcome response) {
      if(response.isOk) {
        List<dynamic> result = response.data;
        List<GoActivity> activities = result.map((data) => GoActivity.fromJson(data)).toList();
        final isLastPage = activities.length.isLessThan(_pageSize);

        if(isLastPage) {
          upcomingActivityController.appendLastPage(activities);
        } else {
          upcomingActivityController.appendPage(activities, page + 1);
        }
      } else {
        upcomingActivityController.error = response.message;
      }
    });
  }

  void _fetchOngoingActivities(int page) async {
    if(ParentController.data.state.isGettingCurrentLocation.value) {
      return Future.delayed(Duration(milliseconds: 500), () => _fetchOngoingActivities(page));
    }

    _connect.get(endpoint: "/go/activity/all/ongoing${_buildFilters(page)}").then((Outcome response) {
      if(response.isOk) {
        List<dynamic> result = response.data;
        List<GoActivity> activities = result.map((data) => GoActivity.fromJson(data)).toList();
        final isLastPage = activities.length.isLessThan(_pageSize);

        if(isLastPage) {
          ongoingActivityController.appendLastPage(activities);
        } else {
          ongoingActivityController.appendPage(activities, page + 1);
        }
      } else {
        ongoingActivityController.error = response.message;
      }
    });
  }

  void _fetchBCaps(int page) async {
    if(ParentController.data.state.isGettingCurrentLocation.value) {
      return Future.delayed(Duration(milliseconds: 500), () => _fetchBCaps(page));
    }

    _connect.get(endpoint: "/go/bcap/all${_buildFilters(page)}").then((Outcome response) {
      if(response.isOk) {
        List<dynamic> result = response.data;
        List<GoBCap> caps = result.map((data) => GoBCap.fromJson(data)).toList();
        final isLastPage = caps.length.isLessThan(_pageSize);

        if(isLastPage) {
          bcapController.appendLastPage(caps);
        } else {
          bcapController.appendPage(caps, page + 1);
        }
      } else {
        bcapController.error = response.message;
      }
    });
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

  GoActivity? get(String id) {
    List<GoActivity> activities = [
      ...activityController.itemList ?? [],
      ...upcomingActivityController.itemList ?? [],
      ...ongoingActivityController.itemList ?? []
    ];

    return activities.find((element) => element.id.equals(id));
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
    load();

    createStream.listen((GoBCapCreate activity) {
      if(activity.hasData) {
        _processGoCreate(activity);
      }
    });

    super.onReady();
  }

  void load() {
    if(ParentController.data.state.isAuthenticated.value) {
      _fetchAccount();
      _fetchInterests();
      _fetchInterestCategories();
      _refreshControllers();
    }
  }

  void _fetchAccount() async {
    state.isGettingAccount.value = true;

    _connect.get(endpoint: "/go/account").then((Outcome response) {
      state.isGettingAccount.value = false;

      if(response.isSuccessful) {
        GoAccount account = GoAccount.fromJson(response.data);
        Database.instance.saveAccount(account);
        state.account.value = account;
      } else {
        notify.error(message: response.message);
      }
    });
  }

  void _fetchInterests() async {
    state.isFetchingInterests.value = true;

    _connect.get(endpoint: "/go/interest").then((Outcome response) {
      state.isFetchingInterests.value = false;

      if(response.isSuccessful) {
        List<GoInterest> interests = (response.data as List).map((e) => GoInterest.fromJson(e)).toList();
        Database.instance.saveInterests(interests);
        state.interests.value = interests;
      } else {
        notify.error(message: response.message);
      }
    });
  }

  void _fetchInterestCategories() async {
    state.isFetchingInterestCategories.value = true;

    _connect.get(endpoint: "/go/interest/category").then((Outcome response) {
      state.isFetchingInterestCategories.value = false;

      if(response.isSuccessful) {
        List<GoInterestCategory> categories = (response.data as List).map((e) => GoInterestCategory.fromJson(e)).toList();

        Database.instance.saveInterestCategories(categories);
        state.categories.value = categories;
      } else {
        notify.error(message: response.message);
      }
    });
  }

  void _refreshControllers() {
    activityController.refresh();
    upcomingActivityController.refresh();
    ongoingActivityController.refresh();
    bcapController.refresh();
  }

  void updateRecentAddresses(Address address) {
    List<Address> update = List.from(Database.instance.recentAddresses);
    if(!update.any((ad) => (ad.latitude.equals(address.latitude) && ad.longitude.equals(address.longitude)) || ad.place.equalsIgnoreCase(address.place))) {
      update.add(address);

      Database.instance.saveRecentAddress(update);
      state.addressHistory.value = update;
    }
  }

  void updateRecentShops(SearchShopResponse shop, ButtonView option) async {
    List<SearchShopResponse> update = List.from(Database.instance.recentSearch);
    if(!update.any((item) => item.shop.id.equals(shop.shop.id))) {
      update.add(shop);

      Database.instance.saveRecentSearch(update);
      state.shopHistory.value = update;
    }

    _connect.post(endpoint: "/nearby/drive", body: {
      "id": shop.shop.id,
      "type": shop.shop.category,
      "provider": shop.isGoogle ? "GOOGLE" : "SERCH",
      "option": option.header
    });
  }

  void onGoCreateUploadRetry(GoBCapCreateUpload upload) {
    upload = upload.copyWith(hasError: false, isLoading: true);
    List<GoBCapCreateUpload> uploads = List.from(state.uploads);

    if(uploads.any((GoBCapCreateUpload element) => element.id.equals(upload.id))) {
      uploads[uploads.indexWhere((GoBCapCreateUpload element) => element.id.equals(upload.id))] = upload;
      state.uploads.value = uploads;
    }

    _processGoCreateUpload(upload);
  }

  void onGoCreateUploadDismiss(GoBCapCreateUpload upload) {
    List<GoBCapCreateUpload> uploads = List.from(state.uploads);
    uploads.removeWhere((GoBCapCreateUpload element) => element.id.equals(upload.id));
    state.uploads.value = uploads;
  }

  void _processGoCreate(GoBCapCreate create) async {
    int id = state.uploads.length + 1;
    GoBCapCreateUpload upload = GoBCapCreateUpload(id: id, isLoading: true, create: create);

    List<GoBCapCreateUpload> uploads = List.from(state.uploads);
    uploads.add(upload);
    state.uploads.value = uploads;

    Navigate.all(ParentLayout.route);
    _processGoCreateUpload(upload);
  }

  void _processGoCreateUpload(GoBCapCreateUpload upload) {
    ConnectService connect = Connect();

    connect.post(endpoint: "/go/bcap/create", body: upload.create.toJson()).then((Outcome response) {
      List<GoBCapCreateUpload> uploads = List.from(state.uploads);

      if(response.isSuccessful) {
        GoBCap bcap = GoBCap.fromJson(response.data);
        GoActivity? activity = get(upload.create.id);

        if(activity.isNotNull) {
          activity = activity!.copyWith(bcap: bcap.id);
          onGoActivityUpdated(activity);
          ActivityController.data.updateActivity(bcap.id, activity.id);
        }

        if(uploads.any((GoBCapCreateUpload element) => element.id.equals(upload.id))) {
          uploads.removeWhere((GoBCapCreateUpload element) => element.id.equals(upload.id));
          state.uploads.value = uploads;
        }

        bcapController.itemList = [bcap, ...bcapController.itemList ?? []];
      } else {
        upload = upload.copyWith(hasError: true, isLoading: false);

        if(uploads.any((GoBCapCreateUpload element) => element.id.equals(upload.id))) {
          uploads[uploads.indexWhere((GoBCapCreateUpload element) => element.id.equals(upload.id))] = upload;
          state.uploads.value = uploads;
        }

        notify.tip(message: response.message, color: CommonColors.instance.error);
      }
    });
  }

  void updateActivityList(GoActivity activity) {
    activityController.itemList = [activity, ...activityController.itemList ?? []];

    if(activity.isPending) {
      upcomingActivityController.itemList = [activity, ...upcomingActivityController.itemList ?? []];
    } else if(activity.isOngoing) {
      ongoingActivityController.itemList = [activity, ...ongoingActivityController.itemList ?? []];
    }
  }

  @override
  void onClose() {
    activityController.dispose();
    upcomingActivityController.dispose();
    ongoingActivityController.dispose();
    bcapController.dispose();

    super.onClose();
  }
}
import 'package:drive/library.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart' show ButtonView, IntExtensions, IterableExtension, PagedController, TExtensions;

import 'go_activity_state.dart';

class GoActivityController extends GetxController {
  GoActivityController();
  static GoActivityController? get data {
    try {
      return Get.find<GoActivityController>();
    } catch (_) {
      return null;
    }
  }

  final state = GoActivityState();

  final ConnectService _connect = Connect();

  final int _pageSize = 20;

  final PagedController<int, GoActivity> attendingController = PagedController(firstPageKey: 0);
  final PagedController<int, GoActivity> attendedController = PagedController(firstPageKey: 0);

  List<ButtonView> tabs = [
    ButtonView(header: "Attending Activities"),
    ButtonView(header: "Attended Activities"),
  ];

  @override
  void onReady() {
    attendingController.addPageRequestListener(_fetchAttendingActivities);
    attendedController.addPageRequestListener(_fetchAttendedActivities);

    super.onReady();
  }

  void _fetchAttendingActivities(int page) async {
    if(ParentController.data.state.isGettingCurrentLocation.value) {
      return Future.delayed(Duration(milliseconds: 500), () => _fetchAttendingActivities(page));
    }

    _connect.get(endpoint: "/go/activity/all/attending${_buildFilters(page)}").then((Outcome response) {
      if(response.isOk) {
        List<dynamic> result = response.data;
        List<GoActivity> activities = result.map((data) => GoActivity.fromJson(data)).toList();
        final isLastPage = activities.length.isLessThan(_pageSize);

        if(isLastPage) {
          attendingController.appendLastPage(activities);
        } else {
          attendingController.appendPage(activities, page + 1);
        }
      } else {
        attendingController.error = response.message;
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

    return "?page=$page&size=$_pageSize&lat=$latitude&lng=$longitude";
  }

  void _fetchAttendedActivities(int page) async {
    if(ParentController.data.state.isGettingCurrentLocation.value) {
      return Future.delayed(Duration(milliseconds: 500), () => _fetchAttendedActivities(page));
    }

    _connect.get(endpoint: "/go/activity/all/attended${_buildFilters(page)}").then((Outcome response) {
      if(response.isOk) {
        List<dynamic> result = response.data;
        List<GoActivity> activities = result.map((data) => GoActivity.fromJson(data)).toList();
        final isLastPage = activities.length.isLessThan(_pageSize);

        if(isLastPage) {
          attendedController.appendLastPage(activities);
        } else {
          attendedController.appendPage(activities, page + 1);
        }
      } else {
        attendedController.error = response.message;
      }
    });
  }

  GoActivityUpdated get onGoActivityUpdated => (GoActivity activity) {
    List<GoActivity> activities = attendingController.itemList ?? [];
    int index = activities.findIndex((element) => element.id.equals(activity.id));

    if(index.notEquals(-1)) {
      activities[index] = activity;
      attendingController.itemList = activities;
    } else {
      activities = attendedController.itemList ?? [];
      index = activities.findIndex((element) => element.id.equals(activity.id));

      if(index.notEquals(-1)) {
        activities[index] = activity;
        attendedController.itemList = activities;
      }
    }
  };

  GoActivityUpdated get onGoActivityDeleted => (GoActivity activity) {
    List<GoActivity> activities = attendingController.itemList ?? [];
    int index = activities.findIndex((element) => element.id.equals(activity.id));

    if(Get.isBottomSheetOpen ?? false) {
      Navigate.close(closeAll: false);
    }

    if(index.notEquals(-1)) {
      activities.removeAt(index);
      attendingController.itemList = activities;
    } else {
      activities = attendedController.itemList ?? [];
      index = activities.findIndex((element) => element.id.equals(activity.id));

      if(index.notEquals(-1)) {
        activities.removeAt(index);
        attendedController.itemList = activities;
      }
    }
  };

  void updateCurrent(int index) {
    state.current.value = index;
  }

  @override
  void onClose() {
    attendingController.dispose();
    attendedController.dispose();

    super.onClose();
  }
}
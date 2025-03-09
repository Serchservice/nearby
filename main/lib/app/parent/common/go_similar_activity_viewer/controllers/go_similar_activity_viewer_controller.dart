import 'package:drive/library.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

import 'go_similar_activity_viewer_state.dart';

class GoSimilarActivityViewerController extends GetxController {
  GoSimilarActivityViewerController();
  final GoSimilarActivityViewerState state = GoSimilarActivityViewerState();

  final ConnectService _connect = Connect();

  final int _pageSize = 20;
  late PagedController<int, GoActivity> activityController;
  GoActivityListUpdated? onListUpdate;

  Map<String, String?> params = Get.parameters;
  dynamic args = Get.arguments;

  @override
  void onInit() {
    if(Instance.of<GoActivity>(args["activity"])) {
      state.activity.value = args["activity"];
    }

    if(Instance.of<bool>(args["is_others"])) {
      state.isOthers.value = args["is_others"];
    }

    if(Instance.of<GoActivityListUpdated>(args["on_list_updated"])) {
      onListUpdate = args["on_list_updated"];
    }

    int firstPage = 0;
    if(Instance.of<List<GoActivity>>(args["activities"])) {
      List<GoActivity> activities = args["activities"];
      activityController = PagedController.fromValue(
        Paged<int, GoActivity>(itemList: activities, nextPageKey: activities.length / _pageSize as int),
        firstPageKey: firstPage
      );
    } else {
      activityController = PagedController<int, GoActivity>(firstPageKey: firstPage);
    }

    activityController.addPageRequestListener(_fetchActivities);

    super.onInit();
  }

  void _fetchActivities(int page) async {
    String baseUrl = "/go/activity/$activityId";
    String endpoint = state.isOthers.value ? "/similar" : "/related";

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

    String params = "?page=$page&size=$_pageSize&lat=$latitude&lng=$longitude";

    String url = "$baseUrl$endpoint$params";
    _connect.get(endpoint: url).then((Outcome response) {
      if(response.isSuccessful) {
        List<dynamic> list = response.data;
        List<GoActivity> activities = list.map((dynamic item) => GoActivity.fromJson(item)).toList();
        final isLastPage = activities.length.isLessThan(_pageSize);

        if(isLastPage) {
          activityController.appendLastPage(activities);
        } else {
          activityController.appendPage(activities, page + 1);
        }

        onListUpdated(activityController.itemList ?? []);
      } else {
        activityController.error = response.message;
      }
    });
  }

  GoActivityListUpdated get onListUpdated => onListUpdate ?? (List<GoActivity> activities) {};

  String get activityId => params["id"] ?? state.activity.value.id;

  String get title => state.isLoading.value
      ? "Loading..."
      : state.isOthers.value
      ? "Similar ${state.activity.value.name} activities from other creators"
      : "Similar ${state.activity.value.name} activities from ${state.activity.value.user?.firstName ?? "creator"}";

  @override
  void onReady() {
    _fetchActivity();

    super.onReady();
  }

  void _fetchActivity() {
    if(state.activity.value.hasActivity) {
      return;
    } else {
      state.isLoading.value = true;
      String url = "/go/activity/$activityId";

      _connect.get(endpoint: url).then((Outcome response) {
        if(response.isSuccessful) {
          state.isLoading.value = false;

          GoActivity activity = GoActivity.fromJson(response.data);
          state.activity.value = activity;
        } else {
          notify.tip(message: response.message, color: CommonColors.instance.error);
        }
      });
    }
  }

  @override
  void onClose() {
    activityController.dispose();

    super.onClose();
  }
}
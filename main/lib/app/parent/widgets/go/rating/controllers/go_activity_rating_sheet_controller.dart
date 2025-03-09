import 'package:drive/library.dart';
import 'package:get/get.dart';
import 'package:smart/smart.dart';

import 'go_activity_rating_sheet_state.dart';

class GoActivityRatingSheetController extends GetxController {
  final List<GoActivityRating> ratings;
  final String activity;
  final GoActivityRatingListUpdated onUpdated;
  final bool canRate;

  GoActivityRatingSheetController({
    required this.ratings,
    required this.activity,
    required this.onUpdated,
    required this.canRate
  });

  final GoActivityRatingSheetState state = GoActivityRatingSheetState();

  final ConnectService _connect = Connect();

  final int _pageSize = 20;
  late PagedController<int, GoActivityRating> ratingController;

  @override
  void onInit() {
    int firstPage = 0;

    if(ratings.isNotEmpty) {
      ratingController = PagedController.fromValue(
        Paged<int, GoActivityRating>(itemList: ratings, nextPageKey: (ratings.length / _pageSize).toInt()),
        firstPageKey: firstPage
      );
    } else {
      ratingController = PagedController(firstPageKey: firstPage);
    }
    ratingController.addPageRequestListener(_fetch);
    _prepareInfo();

    super.onInit();
  }

  void _prepareInfo() {
    (ratingController.itemList ?? []).any((GoActivityRating r) => r.isCurrentUser)
        ? state.info.value = "You have already rated your experience on this activity."
        : state.info.value = info;
  }

  void _fetch(int page) async {
    _connect.get(endpoint: "/go/rating/$activity?page=$page&size=$_pageSize").then((Outcome response) {
      if(response.isSuccessful) {
        List<dynamic> list = response.data;
        List<GoActivityRating> ratings = list.map((dynamic item) => GoActivityRating.fromJson(item)).toList();
        final isLastPage = ratings.length.isLessThan(_pageSize);

        if(isLastPage) {
          ratingController.appendLastPage(ratings);
        } else {
          ratingController.appendPage(ratings, page + 1);
        }

        _prepareInfo();
        onUpdated(ratingController.itemList ?? []);
      } else {
        ratingController.error = response.message;
      }
    });
  }

  String get info => Database.instance.auth.isLoggedIn
      ? "Rating is reserved for users that attended this activity."
      : "Log in to rate your experience on this activity.";

  bool get showRatingBuilder => canRate;

  void rate() async {
    state.isRating.value = true;
    JsonMap payload = {
      "id": activity,
      "rating": state.rating.value
    };

    _connect.post(endpoint: "/go/rating", body: payload).then((Outcome response) {
      if(response.isSuccessful) {
        GoActivityRating rating = GoActivityRating.fromJson(response.data);

        List<GoActivityRating> ratings = List.from(ratingController.value.itemList ?? []);
        int index = ratings.indexWhere((GoActivityRating c) => c.id.equals(rating.id));
        if(index.notEquals(-1)) {
          ratings[index] = rating;
        } else {
          ratings.insert(0, rating);
        }

        state.isRating.value = false;
        state.rating.value = 0.0;

        ratingController.itemList = ratings;
        onUpdated(ratings);
      } else {
        state.isRating.value = false;
        notify.tip(message: response.message, color: CommonColors.instance.error);
      }
    });
  }

  @override
  void onClose() {
    ratingController.removePageRequestListener(_fetch);
    ratingController.dispose();

    super.onClose();
  }
}
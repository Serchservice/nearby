import 'dart:async';

import 'package:drive/library.dart';
import 'package:flutter/material.dart' show CarouselController, ScrollPosition, TimeOfDay;
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:smart/smart.dart';

import 'go_activity_card_state.dart';

class GoActivityCardController extends GetxController {
  final GoActivity activity;

  GoActivityCardController({required this.activity});

  final state = GoActivityCardState();

  Timer? _timer;
  final CarouselController carouselController = CarouselController(initialItem: 0);

  @override
  void onInit() {
    state.activity.value = activity;
    state.totalImageCount.value = images.length;

    List<GoUser> attendingUsers = List.from(activity.attendingUsers);

    if(activity.user.isNotNull && attendingUsers.contains(activity.user).isFalse && activity.attendingUsers.isNotEmpty) {
      attendingUsers.add(activity.user!);
    }
    state.attendingUsers.value = attendingUsers;

    super.onInit();
  }

  @override
  void onReady() {
    _startTimer();

    carouselController.addListener(_carouselListener);

    super.onReady();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTimings();
    });
  }

  void _updateTimings() {
    DateTime now = DateTime.now();
    DateTime? activityDate = _parseTimestamp(state.activity.value.timestamp);
    if(activityDate.isNotNull) {
      DateTime? startDateTime = _convertToDateTime(activityDate!, state.activity.value.startTime);
      DateTime? endDateTime = _convertToDateTime(activityDate, state.activity.value.endTime);

      // Calculate start timing for any activity that is UPCOMING
      if(startDateTime.isNotNull && state.activity.value.isClosed.isFalse && state.activity.value.isPending) {
        if(now.isBefore(startDateTime!)) {
          Duration diff = startDateTime.difference(now);
          state.startTiming.value = _formatDuration(diff);
        } else {
          state.startTiming.value = "Ongoing";
          GoActivity activity = state.activity.value;
          state.activity.value = state.activity.value.copyWith(status: "ACTIVE");

          if(Database.instance.auth.isLoggedIn && activity.isCreatedByCurrentUser && activity.isPending) {
            ActivityService.instance.start(activity: state.activity.value, onUpdated: (GoActivity activity) {
              state.activity.value = activity;
              ActivityController.data.onGoActivityUpdated(activity);
              CentreController.data.onGoActivityUpdated(activity);
            });
          }
        }
      }

      // Calculate end timing for any activity that is ONGOING
      if(endDateTime.isNotNull && state.activity.value.isClosed.isFalse && state.activity.value.isOngoing) {
        if (now.isBefore(endDateTime!)) {
          Duration diff = endDateTime.difference(now);
          state.endTiming.value = _formatDuration(diff);
        } else {
          state.endTiming.value = "Ended";
          GoActivity activity = state.activity.value;
          state.activity.value = state.activity.value.copyWith(status: "CLOSED");

          if(Database.instance.auth.isLoggedIn && activity.isCreatedByCurrentUser && activity.isOngoing) {
            ActivityService.instance.end(activity: state.activity.value, onUpdated: (GoActivity activity) {
              state.activity.value = activity;
              ActivityController.data.onGoActivityUpdated(activity);
              CentreController.data.onGoActivityUpdated(activity);
            });
          }
        }
      }
    }
  }

  DateTime? _parseTimestamp(String timestamp) {
    final RegExp regex = RegExp(r"(\d{1,2}) (\w+), (\d{4})");
    final match = regex.firstMatch(timestamp);

    if (match != null) {
      int day = int.parse(match.group(1)!);
      String month = match.group(2)!;
      int year = int.parse(match.group(3)!);

      // Convert month name to number
      DateTime parsedDate = DateFormat("d MMMM, yyyy").parse("$day $month, $year");
      return DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
    }

    return null;
  }

  DateTime? _convertToDateTime(DateTime activityDate, String time) {
    TimeOfDay? parsedTime = parse(time);

    if(parsedTime.isNotNull) {
      return DateTime(
        activityDate.year,
        activityDate.month,
        activityDate.day,
        parsedTime!.hour,
        parsedTime.minute,
      );
    }

    return null;
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return "In ${duration.inHours}hr ${duration.inMinutes.remainder(60)}min";
    } else if (duration.inMinutes > 0) {
      return "In ${duration.inMinutes}min";
    } else if (duration.inSeconds > 0) {
      return "In ${duration.inSeconds}sec";
    } else {
      return "Now";
    }
  }

  TimeOfDay? parse(String time) {
    final RegExp regExp = RegExp(r"(\d{1,2}):(\d{2})\s?(AM|PM)");
    final match = regExp.firstMatch(time.toUpperCase());

    if (match != null) {
      int hour = int.parse(match.group(1)!);
      int minute = int.parse(match.group(2)!);
      String period = match.group(3)!;

      if (period == "PM" && hour != 12) hour += 12;
      if (period == "AM" && hour == 12) hour = 0;

      return TimeOfDay(hour: hour, minute: minute);
    }

    return null;
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

  List<GoFile> get images => state.activity.value.images;

  List<SelectedMedia> get resources => images.map((GoFile image) => SelectedMedia(path: image.file)).toList();

  List<String> get attendingUserAvatars => state.attendingUsers.map((GoUser user) => user.avatar).toList();

  double get contentHeight => 250;

  bool get showNotify => state.activity.value.isClosed.isFalse
      && state.activity.value.hasResponded.isFalse
      && state.activity.value.isCreatedByCurrentUser.isFalse;

  String get timing => state.activity.value.isClosed
      ? "Ended | ${state.activity.value.startTime} - ${state.activity.value.endTime}"
      : state.activity.value.isOngoing
      ? "Ongoing | Ends ${state.endTiming.value.toLowerCase()}"
      : "Upcoming | Starts ${state.startTiming.value.toLowerCase()}";

  @override
  void onClose() {
    carouselController.removeListener(_carouselListener);
    carouselController.dispose();
    _timer?.cancel();

    super.onClose();
  }
}
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:smart/smart.dart';
import 'package:drive/library.dart';

class CommonUtility {
  static void copy(String text, {String? message}) {
    try {
      final data = ClipboardData(text: text);
      Clipboard.setData(data);
      notify.tip(message: message ?? "Copied");
    } on Exception catch (e) {
      notify.error(message: e.toString());
    }
  }

  static void unfocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static String formatTime(DateTime dateTime) {
    // You can customize this function to format the time part as needed
    return DateFormat('h:mm a').format(dateTime);
  }

  static String formatDay(DateTime? dateTime, {bool showTime = true}) {
    if (dateTime != null) {
      DateTime current = DateTime.now();
      DateTime currentDateTime = DateTime(current.year, current.month, current.day);
      DateTime date = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if(showTime) {
        if (date.equals(currentDateTime)) {
          return 'Today, ${formatTime(dateTime)}';
        } else if (date.equals(currentDateTime.subtract(const Duration(days: 1)))) {
          return 'Yesterday, ${formatTime(dateTime)}';
        } else {
          DateFormat formatter = DateFormat('EEEE, d MMMM yyyy');
          return formatter.format(dateTime);
        }
      } else {
        DateFormat formatter = DateFormat('EEEE, d MMMM yyyy');
        String result = formatter.format(dateTime);

        if (date.equals(currentDateTime)) {
          return 'Today, $result';
        } else if (date.equals(currentDateTime.subtract(const Duration(days: 1)))) {
          return 'Yesterday, $result';
        } else {
          return result;
        }
      }
    } else {
      return '';
    }
  }

  static DateFormat timeFormat(String pattern) => DateFormat(pattern);

  static StreamSubscription<dynamic> fetch({required Function action, int durationInSeconds = 10}) {
    return Stream.periodic(Duration(seconds: durationInSeconds)).listen((_) {
      Future<void>.delayed(const Duration(milliseconds: 500), () async {
        action();
      });
    });
  }

  static Future<String> getTimezone() async => await FlutterTimezone.getLocalTimezone();
}
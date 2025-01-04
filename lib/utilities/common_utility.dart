import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
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

  static String greeting() {
    var hour = DateTime.now().hour;
    if(hour < 12) {
      return 'Good Morning,';
    }
    if(hour < 16) {
      return 'Good Afternoon,';
    }
    if(hour < 20) {
      return 'Good Evening,';
    }
    return 'Hi there,';
  }

  static String statements() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'What provider can we get for you?';
    }
    if (hour < 16) {
      return 'Sunny or rainy, we always got your back.';
    }
    if(hour < 20) {
      return 'While the moon is out, we never say bye!';
    }
    return 'Service made easy whenever you need it.';
  }

  static String capitalizeWords(String input) {
    if (input.isEmpty) {
      return input;
    }

    List<String> words = input.split(' ');
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      if (word.isNotEmpty) {
        words[i] = '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
      }
    }

    return words.join(' ');
  }

  static void unfocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static String textWithAorAn(String text) {
    if(text.startsWith(RegExp('[aeiouAEIOU]'))) {
      return "an ${text.toLowerCase()}";
    } else {
      return "a ${text.toLowerCase()}";
    }
  }

  static String formatTime(DateTime dateTime) {
    // You can customize this function to format the time part as needed
    return DateFormat('h:mm a').format(dateTime);
  }

  static String formatDay(DateTime? dateTime, {bool showTime = true}) {
    if (dateTime != null) {
      DateTime currentDateTime = DateTime.now();

      if(showTime) {
        if (isSameDate(dateTime, currentDateTime)) {
          return 'Today, ${formatTime(dateTime)}';
        } else if (isSameDate(dateTime, currentDateTime.subtract(const Duration(days: 1)))) {
          return 'Yesterday, ${formatTime(dateTime)}';
        } else {
          DateFormat formatter = DateFormat('EEEE, d MMMM yyyy');
          return formatter.format(dateTime);
        }
      } else {
        DateFormat formatter = DateFormat('EEEE, d MMMM yyyy');
        return formatter.format(dateTime);
      }
    } else {
      return '';
    }
  }

  static bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  static Color lightenColor(Color color, double percent) {
    assert(0 <= percent && percent <= 100, 'Percent must be between 0 and 100');

    HSLColor hsl = HSLColor.fromColor(color);
    double lightness = (hsl.lightness + percent / 100).clamp(0.0, 1.0);

    // Return a new color with the adjusted lightness
    return hsl.withLightness(lightness).toColor();
  }

  static List<int> generateList(int count) {
    return List.generate(count, (index) => index);
  }
}
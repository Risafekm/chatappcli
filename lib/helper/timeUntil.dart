import 'package:flutter/material.dart';

class TimeUntil {
  static String getTimeUntil(BuildContext context, String time) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessage(BuildContext context, String time) {
    final DateTime send = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == send.day &&
        now.month == send.month &&
        now.year == send.year) {
      return TimeOfDay.fromDateTime(send).format(context);
    }
    return '${send.day} ${getMonths(send)}';
  }

  static String getMonths(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';

      default:
        return 'NA';
    }
  }
}

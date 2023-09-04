// ignore_for_file: file_names

import 'package:flutter/material.dart';

class TimeUntil {
  static String getTimeUntil(BuildContext context, String time) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  // last message time

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

  //get formatted last active time of user in chat screen
  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;

    //if time is not available then return below statement
    if (i == -1) return 'Last seen not available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == time.year) {
      return 'Last seen today at $formattedTime';
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }

    String month = getMonths(time);

    return 'Last seen on ${time.day} $month on $formattedTime';
  }

  //current month
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

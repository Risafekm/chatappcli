import 'package:flutter/material.dart';

class TimeUntil {
  static String getTimeUntil(BuildContext context, String time) {
    // final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(
            DateTime.fromMillisecondsSinceEpoch(int.parse(time)))
        .format(context);
  }
}

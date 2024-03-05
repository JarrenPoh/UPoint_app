import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeTransfer {
  //將datePublished 變成 "01/01（一）"
  static String timeTrans01(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    List<String> weekdays = ["(日)", "(一)", "(二)", "(三)", "(四)", "(五)", "(六)"];
    String formattedDate =
        DateFormat('MM/dd').format(dateTime) + weekdays[dateTime.weekday % 7];
    return formattedDate;
  }

  //firebase TimeStamp to 13:20
  static String timeTrans02(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateFormat outputFormat = DateFormat("HH:mm");
    String convertedTime = outputFormat.format(dateTime);
    return convertedTime;
  }

  //start&end TimeStamp to 113/02/09 13:00~17:00
  static String timeTrans03(Timestamp startTime, Timestamp endTime) {
    String _start = TimeTransfer.timeTrans01(startTime);
    String _end = TimeTransfer.timeTrans01(endTime);
    if (_start == _end) {
      return "$_start ${TimeTransfer.timeTrans02(startTime)}  ~  ${TimeTransfer.timeTrans02(endTime)}";
    } else {
      return "$_start ${TimeTransfer.timeTrans02(startTime)}  ~  $_end${TimeTransfer.timeTrans02(endTime)}";
    }
  }

  //時間模型-> 13:20 PM
  static String timeTrans04(BuildContext context, TimeOfDay selectedTime) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String formattedTime = localizations.formatTimeOfDay(selectedTime,
        alwaysUse24HourFormat: false);
    return formattedTime;
  }

  //start&end TimeStamp to 02/09 ~ 02/10
  static String timeTrans05(Timestamp startTime, Timestamp endTime) {
    String _start = TimeTransfer.timeTrans01(startTime);
    String _end = TimeTransfer.timeTrans01(endTime);
    if (_start == _end) {
      return _start;
    } else {
      return "$_start ~ $_end";
    }
  }

  //start&end TimeStamp to 2024-09-15 20:54
  static String timeTrans06(Timestamp time) {
    DateTime dateTime = time.toDate();
    String dateStr = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
    return "$dateStr ${timeTrans02(time)}";
  }

  //DateTime -> 91-09-15
  static String convertToROC(DateTime date) {
    // 计算民国年份
    int rocYear = date.year - 1911;
    // 格式化为 "民國年-MM-dd"
    return '民國${rocYear}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

String relativeDateFormat(DateTime date) {
  num delta =
      DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;
  if (delta < 1 * ONE_MINUTE) {
    // num seconds = toSeconds(delta);
    return '剛剛';
  }
  if (delta < 60 * ONE_MINUTE) {
    num minutes = toMinutes(delta);
    return (minutes <= 0 ? 1 : minutes).toInt().toString() + ONE_MINUTE_AGO;
  }
  if (delta < 24 * ONE_HOUR) {
    num hours = toHours(delta);
    return (hours <= 0 ? 1 : hours).toInt().toString() + ONE_HOUR_AGO;
  }
  if (delta < 48 * ONE_HOUR) {
    return "昨天";
  }
  if (delta < 30 * ONE_DAY) {
    num days = toDays(delta);
    return (days <= 0 ? 1 : days).toInt().toString() + ONE_DAY_AGO;
  }
  if (delta < 12 * 4 * ONE_WEEK) {
    String title = DateFormat.yMMMMd('zh_Hans_CN').format(date);
    return title;
  } else {
    String title = DateFormat.yMMMMd('zh_Hans_CN').format(date);
    return title;
  }
}

final num ONE_MINUTE = 60000;
final num ONE_HOUR = 3600000;
final num ONE_DAY = 86400000;
final num ONE_WEEK = 604800000;

final String ONE_SECOND_AGO = "秒前";
final String ONE_MINUTE_AGO = "分鐘前";
final String ONE_HOUR_AGO = "小時前";
final String ONE_DAY_AGO = "天前";
num toSeconds(num date) {
  return date / 1000;
}

num toMinutes(num date) {
  return toSeconds(date) / 60;
}

num toHours(num date) {
  return toMinutes(date) / 60;
}

num toDays(num date) {
  return toHours(date) / 24;
}

num toMonths(num date) {
  return toDays(date) / 30;
}

num toYears(num date) {
  return toMonths(date) / 365;
}

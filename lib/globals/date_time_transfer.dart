import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime dateTime, bool isDate) {
  // 定义日期格式
  final DateFormat dateFormat = DateFormat('yyyy,MM,dd');
  final DateFormat timeFormat = DateFormat('HH:mm');

  // 将DateTime对象格式化为字符串
  return isDate == true
      ? dateFormat.format(dateTime)
      : timeFormat.format(dateTime);
}

DateTime parseDateString(String dateString, bool isDate) {
  // 定义日期格式
  final DateFormat dateFormat = DateFormat('yyyy,MM,dd');
  final DateFormat timeFormat = DateFormat('HH:mm');

  // 尝试将字符串解析为DateTime对象
  try {
    return isDate == true
        ? dateFormat.parse(dateString)
        : timeFormat.parse(dateString);
  } catch (e) {
    print('Failed to parse date: $dateString');
    return DateTime.now(); // 如果解析失败，返回当前时间
  }
}

//將datePublished 變成 "01/01（週一）"
String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return DateFormat('MM/dd（E）', 'zh').format(dateTime);
}

bool isOverTime(
  String timeString,
  DateTime eventDate,
) {
  List<String> timeParts = timeString.split(':');
  eventDate = DateTime(
    eventDate.year,
    eventDate.month,
    eventDate.day,
    int.parse(timeParts[0]),
    int.parse(timeParts[1]),
  );
  return eventDate.isBefore(DateTime.now());
}

String relativeDateFormat(DateTime date) {

  num delta =
      DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;
  if (delta < 1 * ONE_MINUTE) {
    num seconds = toSeconds(delta);
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

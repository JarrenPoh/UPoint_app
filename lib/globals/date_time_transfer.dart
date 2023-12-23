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

import 'package:intl/intl.dart';

Map weekdays = {
  1: '星期一',
  2: '星期二',
  3: '星期三',
  4: '星期四',
  5: '星期五',
  6: '星期六',
  7: '星期七',
};

class MyDate {
  static DateTime getNow() {
    return new DateTime.now();
  }

  /// 不传参数时返回当前时间
  ///
  /// 参数可为 DateTime类型或者 有关的 字符串
  ///
  ///   字符串可为 标准的 DateTime字符串
  ///
  ///   也可以为 20:05 这种只包含时间的字符串
  static DateTime? parse([date]) {
    return date == null
        ? MyDate.getNow()
        : date.runtimeType == DateTime ? date : MyDate._parse(date);
  }

  static DateTime? _parse(String str) {
    if (str.contains('-')) return DateTime.tryParse(str);

    String prefix = MyDate.format('yyyy-MM-dd');
    return DateTime.tryParse('$prefix $str');
  }

  /*
   * 获取每个月的天数 
   */
  static int daysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  /// newPattern 日期格式化字符串,比如'yyyy-MM-dd'
  /// date DateTime 或者 字符串 2020-03-17 等
  static String format(String newPattern, [dynamic date]) {
    return new DateFormat(newPattern).format(MyDate.parse(date)!);
  }

  static String? weekday(DateTime date) {
    return weekdays[date.weekday];
  }

  static bool isAtSameDay(DateTime day1, DateTime day2) {
    return day1 != null &&
        day2 != null &&
        day1.difference(day2).inDays == 0 &&
        day1.day == day2.day;
  }

  static bool isInRange(DateTime date, DateTime? start, DateTime? end) {
    if (start == null && end == null) return true;
    if (start == null && end != null)
      return date.isBefore(end) || date.isAtSameMomentAs(end);
    if (end == null && start != null)
      return date.isAfter(start) || date.isAtSameMomentAs(start);

    return (date.isAfter(start!) && date.isBefore(end!)) ||
        date.isAtSameMomentAs(start) ||
        date.isAtSameMomentAs(end!);
  }
}

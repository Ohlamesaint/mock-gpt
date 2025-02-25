class DateConversionUtils {
  static String convertDateTimeToString(DateTime date) {
    final hour = date.hour % 12;
    final minutesString =
        date.minute < 10 ? "0${date.minute}" : date.minute.toString();
    final hourString = hour == 0 ? "12" : hour.toString();
    return "$hourString:$minutesString ${date.hour > 12 ? "PM" : "AM"}";
  }
}

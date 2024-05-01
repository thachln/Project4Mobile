class ListDateTime {
  final DateTime startOfWeek;
  final DateTime endOfWeek;

  final DateTime startOfMonth;
  final DateTime endOfMonth;

  final DateTime firstDayOfQuarter;
  final DateTime lastDayOfQuarter;

  final DateTime startOfYear;
  final DateTime endOfYear;

  ListDateTime(
      {required this.startOfWeek,
      required this.endOfWeek,
      required this.startOfMonth,
      required this.endOfMonth,
      required this.firstDayOfQuarter,
      required this.lastDayOfQuarter,
      required this.startOfYear,
      required this.endOfYear});
}

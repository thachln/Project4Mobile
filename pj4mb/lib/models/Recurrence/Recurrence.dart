
import 'package:pj4mb/models/Bill/FrequencyType.dart';
import 'package:pj4mb/models/User/User.dart';

class Recurrence{
  final int recurrenceId;
  final User user;
  final FrequencyType recurrenceType;
  final DateTime startDate;
  final DateTime endDate;
  final int intervalAmount;


  Recurrence({required this.recurrenceId,required this.user,required this.recurrenceType,required this.startDate,required this.endDate,required this.intervalAmount});


  factory Recurrence.fromJson(Map<String, dynamic> json) {
    return Recurrence(
      recurrenceId: json['recurrenceId'],
      user: User.fromJson(json['user']),
      recurrenceType: FrequencyType.values.firstWhere((e) => e.toString() == 'RecurrenceType.'+json['recurrenceType']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      intervalAmount: json['intervalAmount'],
    );
  }


  Map<String, dynamic> toJson() => {
    'recurrenceId': recurrenceId,
    'user': user.toJson(),
    'recurrenceType': recurrenceType.toString().split('.').last,
    'startDate': startDate.toString(),
    'endDate': endDate.toString(),
    'intervalAmount': intervalAmount,
  };
}
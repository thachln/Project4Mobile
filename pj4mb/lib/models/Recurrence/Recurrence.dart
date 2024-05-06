
import 'package:pj4mb/models/Bill/EndType.dart';
import 'package:pj4mb/models/Bill/FrequencyType.dart';
import 'package:pj4mb/models/Bill/MonthOption.dart';
import 'package:pj4mb/models/User/User.dart';

class Recurrence{
  final int recurrenceId;
  late  int userId;
  final String frequency;
  final int every;
  final String dayOfWeek;
  final MonthOption monthOption;
  late DateTime dueDate;
  final EndType endType;
  late DateTime? endDate;
  final int times;
  late int? timesCompleted;
  final DateTime startDate;



  Recurrence({required this.recurrenceId,required this.userId,required this.frequency,required this.every,required this.dayOfWeek,required this.monthOption,required this.endType,this.endDate,required this.times,required this.timesCompleted,required this.startDate,required this.dueDate});


  factory Recurrence.fromJson(Map<String, dynamic> json) {
    return Recurrence(
        recurrenceId: json['recurrenceId'],
        userId: json['userId'],
        frequency: json['frequency'],
        every: json['every'],
        dayOfWeek: json['dayOfWeek'],
        monthOption: MonthOption.values.firstWhere((e) => e.name == json['monthOption']),
        dueDate: DateTime.parse(json['dueDate']),
        endType: EndType.values.firstWhere((e) => e.name == json['endType']),
        endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
        times: json['times'],
        timesCompleted: json['timesCompleted'] ?? 0,
        startDate: DateTime.parse(json['startDate']),
    );
  }


  Map<String, dynamic> toJson() => {
    'recurrenceId': recurrenceId,
    'userId': userId,
    'frequency': frequency.toLowerCase(),
    'every': every,
    'dayOfWeek': dayOfWeek,
    'monthOption': monthOption.name,
    'dueDate': dueDate.toIso8601String(),
    'endType': endType.name,
    'endDate': endDate?.toIso8601String(),
    'times': times,
    'timesCompleted': timesCompleted,
    'startDate': startDate.toIso8601String(),
  };
}
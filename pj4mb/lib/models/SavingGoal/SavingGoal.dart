
import 'package:pj4mb/models/SavingGoal/EndDateType.dart';


class SavingGoal{
  final int id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime startDate;
  final DateTime? endDate;
  final EndDateType endDateType;
  late int userId;
  final int walletId;

  SavingGoal({required this.id,required this.name,required this.targetAmount,required this.currentAmount,required this.startDate,required this.endDate,required this.endDateType,required this.userId,required this.walletId});

  factory SavingGoal.fromJson(Map<String, dynamic> json) {
    return SavingGoal(
      id: json['id'],
      name: json['name'],
      targetAmount: json['targetAmount'],
      currentAmount: json['currentAmount'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      endDateType: EndDateType.values.firstWhere((e) => e.name == json['endDateType']),
      userId: json['userId'],
      walletId: json['walletId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'targetAmount': targetAmount,
    'currentAmount': currentAmount,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate != null ? endDate!.toIso8601String() : null,
    'endDateType': endDateType.name,
    'userId': userId,
    'walletId': walletId,
  };
}
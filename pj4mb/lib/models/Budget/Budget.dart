import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Recurrence/Recurrence.dart';
import 'package:pj4mb/models/User/User.dart';

class Budget{
  final int budgetId;
  final User user;
  final Category category;
  final double amount;
  final double threshold_amount;
  final DateTime period_start;
  final DateTime period_end;
  final Recurrence recurrence;

  Budget({required this.budgetId,required this.user,required this.category,required this.amount,required this.threshold_amount,required this.period_start,required this.period_end,required this.recurrence});

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      budgetId: json['budgetId'],
      user: User.fromJson(json['user']),
      category: Category.fromJson(json['category']),
      amount: json['amount'],
      threshold_amount: json['threshold_amount'],
      period_start: DateTime.parse(json['period_start']),
      period_end: DateTime.parse(json['period_end']),
      recurrence: Recurrence.fromJson(json['recurrence']),
    );
  }

  Map<String, dynamic> toJson() => {
    'budgetId': budgetId,
    'user': user.toJson(),
    'category': category.toJson(),
    'amount': amount,
    'threshold_amount': threshold_amount,
    'period_start': period_start.toString(),
    'period_end': period_end.toString(),
    'recurrence': recurrence.toJson(),
  };
}
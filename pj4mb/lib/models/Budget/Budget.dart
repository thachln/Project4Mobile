import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Recurrence/Recurrence.dart';
import 'package:pj4mb/models/User/User.dart';

class Budget{
  final int budgetId;
  late int userId;
  final int categoryId;
  final double amount;
  final double threshold_amount;
  final DateTime period_start;
  final DateTime period_end;

  Budget({
    required this.budgetId,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.threshold_amount,
    required this.period_start,
    required this.period_end
  });

  

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      budgetId: json['budgetId'],
      userId: json['userId'],
      categoryId: json['categoryId'],
      amount: json['amount'],
      threshold_amount: json['threshold_amount'],
      period_start: DateTime.parse(json['periodStart']),
      period_end: DateTime.parse(json['periodEnd'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'budgetId': budgetId,
      'userId': userId,
      'categoryId': categoryId,
      'amount': amount,
      'threshold_amount': threshold_amount,
      'periodStart': period_start.toIso8601String(),
      'periodEnd': period_end.toIso8601String()
    };
  }
}

class BudgetResponse {
  late int budgetId;
  late String categoryName;
  late String categoryIcon;
  late double amount;
	late double thresholdAmount;
  
  BudgetResponse({
    required this.budgetId,
    required this.categoryName,
    required this.categoryIcon,
    required this.amount,
    required this.thresholdAmount
  });

  factory BudgetResponse.fromJson(Map<String, dynamic> json) {
    return BudgetResponse(
      budgetId: json['budgetId'],
      categoryName: json['categoryName'],
      categoryIcon: json['categoryIcon'],
      amount: json['amount'],
      thresholdAmount: json['thresholdAmount']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'budgetId': budgetId,
      'categoryName': categoryName,
      'categoryIcon': categoryIcon,
      'amount': amount,
      'thresholdAmount': thresholdAmount
    };
  }

}
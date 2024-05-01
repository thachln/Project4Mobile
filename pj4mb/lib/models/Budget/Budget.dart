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
      period_start: DateTime.parse(json['period_start']),
      period_end: DateTime.parse(json['period_end'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'budgetId': budgetId,
      'userId': userId,
      'categoryId': categoryId,
      'amount': amount,
      'threshold_amount': threshold_amount,
      'period_start': period_start.toIso8601String(),
      'period_end': period_end.toIso8601String()
    };
  }
}

class BudgetResponse extends Budget{
  late String categoryName;
  late String iconCategory;
  BudgetResponse({
    required int budgetId,
    required int userId,
    required int categoryId,
    required double amount,
    required double threshold_amount,
    required DateTime period_start,
    required DateTime period_end,
    required this.categoryName,
    required this.iconCategory
  }) : super(
    budgetId: budgetId,
    userId: userId,
    categoryId: categoryId,
    amount: amount,
    threshold_amount: threshold_amount,
    period_start: period_start,
    period_end: period_end
  );

  factory BudgetResponse.fromJson(Map<String, dynamic> json) {
    return BudgetResponse(
      budgetId: json['budgetId'],
      userId: json['userId'],
      categoryId: json['categoryId'],
      amount: json['amount'],
      threshold_amount: json['threshold_amount'],
      period_start: DateTime.parse(json['period_start']),
      period_end: DateTime.parse(json['period_end']),
      categoryName: json['categoryName'],
      iconCategory: json['iconCategory']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'budgetId': budgetId,
      'userId': userId,
      'categoryId': categoryId,
      'amount': amount,
      'threshold_amount': threshold_amount,
      'period_start': period_start.toIso8601String(),
      'period_end': period_end.toIso8601String(),
      'categoryName': categoryName,
      'iconCategory': iconCategory
    };
  }

}
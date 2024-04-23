import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Recurrence/Recurrence.dart';
import 'package:pj4mb/models/User/User.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';

class Expense{
  final int expenseId;
  final User user;
  final Wallet wallet;
  final double amount;
  final DateTime expenseDate;
  final Category category;
  final String notes;
  final Recurrence recurrence;

  Expense({required this.expenseId,required this.user,required this.wallet,required this.amount,required this.expenseDate,required this.category,required this.notes,required this.recurrence});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      expenseId: json['expenseId'],
      user: User.fromJson(json['user']),
      wallet: Wallet.fromJson(json['wallet']),
      amount: json['amount'],
      expenseDate: DateTime.parse(json['expenseDate']),
      category: Category.fromJson(json['category']),
      notes: json['notes'],
      recurrence: Recurrence.fromJson(json['recurrence']),
    );
  }

  Map<String, dynamic> toJson() => {
    'expenseId': expenseId,
    'user': user.toJson(),
    'wallet': wallet.toJson(),
    'amount': amount,
    'expenseDate': expenseDate.toString(),
    'category': category.toJson(),
    'notes': notes,
    'recurrence': recurrence.toJson(),
  };
}
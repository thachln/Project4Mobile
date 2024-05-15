import 'package:pj4mb/models/Recurrence/Recurrence.dart';

class TransactionRecurrence{
  final int transactionRecurringId;
  late int userId;
  final int walletId;
  final double amount;
  final int categoryId;
  final String? notes;
  final Recurrence recurrence;

  TransactionRecurrence({
    required this.transactionRecurringId,
    required this.userId,
    required this.walletId,
    required this.amount,
    required this.categoryId,
    required this.notes,
    required this.recurrence
  });

  factory TransactionRecurrence.fromJson(Map<String, dynamic> json) {
    return TransactionRecurrence(
      transactionRecurringId: json['transactionRecurringId'],
      userId: json['userId'],
      walletId: json['walletId'],
      amount: json['amount'],
      categoryId: json['categoryId'],
      notes: json['notes'],
      recurrence: Recurrence.fromJson(json['recurrence'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionRecurringId': transactionRecurringId,
      'userId': userId,
      'walletId': walletId,
      'amount': amount,
      'categoryId': categoryId,
      'notes': notes,
      'recurrence': recurrence.toJson()
    };
  }

}
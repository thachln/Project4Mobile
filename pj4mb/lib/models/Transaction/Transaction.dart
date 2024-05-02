import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Recurrence/Recurrence.dart';
import 'package:pj4mb/models/User/User.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';

class Transaction{
  final int transactionId;
  late  int userId;
  final int walletId;
  final double amount;
  final DateTime transactionDate;
  final int categoryId;
  final String notes;


  Transaction({
    required this.transactionId,
    required this.userId,
    required this.walletId,
    required this.amount,
    required this.transactionDate,
    required this.categoryId,
    required this.notes
  });


  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transactionId'],
      userId: json['userId'],
      walletId: json['walletId'],
      amount: json['amount'],
      transactionDate: DateTime.parse(json['transactionDate']),
      categoryId: json['categoryId'],
      notes: json['notes']
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'userId': userId,
      'walletId': walletId,
      'amount': amount,
      'transactionDate': transactionDate.toIso8601String(),
      'categoryId': categoryId,
      'notes': notes
    };
  }
}
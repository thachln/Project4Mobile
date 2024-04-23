import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Recurrence/Recurrence.dart';
import 'package:pj4mb/models/User/User.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';

class Transaction{
  final int transactionId;
  final User user;
  final Wallet wallet;
  final double amount;
  final DateTime transactionDate;
  final Category category;
  final String notes;
  final Recurrence recurrence;

  Transaction({required this.transactionId,required this.user,required this.wallet,required this.amount,required this.transactionDate,required this.category,required this.notes,required this.recurrence});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transactionId'],
      user: User.fromJson(json['user']),
      wallet: Wallet.fromJson(json['wallet']),
      amount: json['amount'],
      transactionDate: DateTime.parse(json['transactionDate']),
      category: Category.fromJson(json['category']),
      notes: json['notes'],
      recurrence: Recurrence.fromJson(json['recurrence']),
    );
  }

  Map<String, dynamic> toJson() => {
    'transactionId': transactionId,
    'user': user.toJson(),
    'wallet': wallet.toJson(),
    'amount': amount,
    'transactionDate': transactionDate.toString(),
    'category': category.toJson(),
    'notes': notes,
    'recurrence': recurrence.toJson(),
  };
}
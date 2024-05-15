import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Recurrence/Recurrence.dart';

class TransRecuResponce{
  final int transactionRecurringId;
  late  int userId;
  final double amount;
  final Recurrence recurrence;
  final Category category;
  final int walletId;


  TransRecuResponce({required this.transactionRecurringId,required this.userId,required this.amount,required this.recurrence,required this.category,required this.walletId});

  factory TransRecuResponce.fromJson(Map<String, dynamic> json) {
    return TransRecuResponce(
      transactionRecurringId: json['transactionRecurringId'],
      userId: json['userId'],
      amount: json['amount'],
      recurrence: Recurrence.fromJson(json['recurrence']),
      category: Category.fromJson(json['category']),
      walletId: json['walletId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'transactionRecurringId': transactionRecurringId,
    'userId': userId,
    'amount': amount,
    'recurrence': recurrence.toJson(),
    'category': category.toJson(),
    'walletId': walletId,
  };

}
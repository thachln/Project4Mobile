
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Recurrence/Recurrence.dart';
import 'package:pj4mb/models/User/User.dart';

class Bill{
  final int billId;
  late  int userId;
  final double amount;
  final Recurrence recurrence;
  final int categoryId;
  final int walletId;


  Bill({required this.billId,required this.userId,required this.amount,required this.recurrence,required this.categoryId,required this.walletId});


  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      billId: json['billId'],
      userId: json['userId'],
      amount: json['amount'],
      recurrence: Recurrence.fromJson(json['recurrence']),
      categoryId: json['categoryId'],
      walletId: json['walletId'],
    );
  }


  Map<String, dynamic> toJson() => {
    'billId': billId,
    'userId': userId,
    'amount': amount,
    'recurrence': recurrence.toJson(),
    'categoryId': categoryId,
    'walletId': walletId,
  };
}
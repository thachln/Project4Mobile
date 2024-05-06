
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Recurrence/Recurrence.dart';
import 'package:pj4mb/models/User/User.dart';

class BillResponse{
  final int billId;
  late  int userId;
  final double amount;
  final Recurrence recurrence;
  final Category category;
  final int walletId;


  BillResponse({required this.billId,required this.userId,required this.amount,required this.recurrence,required this.category,required this.walletId});

  factory BillResponse.fromJson(Map<String, dynamic> json) {
    return BillResponse(
      billId: json['billId'],
      userId: json['userId'],
      amount: json['amount'],
      recurrence: Recurrence.fromJson(json['recurrence']),
      category: Category.fromJson(json['category']),
      walletId: json['walletId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'billId': billId,
    'userId': userId,
    'amount': amount,
    'recurrence': recurrence.toJson(),
    'category': category.toJson(),
    'walletId': walletId,
  };

}
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Recurrence/Recurrence.dart';
import 'package:pj4mb/models/User/User.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';

class Incomce{
  final int incomeId;
  final User user;
  final Wallet wallet;
  final double amount;
  final DateTime incomeDate;
  final Category category;
  final String notes;
  final Recurrence recurrence;

  Incomce({required this.incomeId,required this.user,required this.wallet,required this.amount,required this.incomeDate,required this.category,required this.notes,required this.recurrence});

  factory Incomce.fromJson(Map<String, dynamic> json) {
    return Incomce(
      incomeId: json['incomeId'],
      user: User.fromJson(json['user']),
      wallet: Wallet.fromJson(json['wallet']),
      amount: json['amount'],
      incomeDate: DateTime.parse(json['incomeDate']),
      category: Category.fromJson(json['category']),
      notes: json['notes'],
      recurrence: Recurrence.fromJson(json['recurrence']),
    );
  }

  Map<String, dynamic> toJson() => {
    'incomeId': incomeId,
    'user': user.toJson(),
    'wallet': wallet.toJson(),
    'amount': amount,
    'incomeDate': incomeDate.toString(),
    'category': category.toJson(),
    'notes': notes,
    'recurrence': recurrence.toJson(),
  };


}
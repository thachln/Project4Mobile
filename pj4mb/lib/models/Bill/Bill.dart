
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Recurrence/Recurrence.dart';
import 'package:pj4mb/models/User/User.dart';

class Bill{
  final int billID;
  final User user;
  final String billName;
  final double amount;
  final DateTime dueDate;
  final Recurrence recurrence;
  final Category category;

  //write the constructor
  Bill({required this.billID,required this.user,required this.billName,required this.amount,required this.dueDate,required this.recurrence,required this.category});

  //write fromjson
  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      billID: json['billID'],
      user: User.fromJson(json['user']),
      billName: json['billName'],
      amount: json['amount'],
      dueDate: DateTime.parse(json['dueDate']),
      recurrence: Recurrence.fromJson(json['recurrence']),
      category: Category.fromJson(json['category']),
    );
  }

  //write tojson
  Map<String, dynamic> toJson() => {
    'billID': billID,
    'user': user.toJson(),
    'billName': billName,
    'amount': amount,
    'dueDate': dueDate.toString(),
    'recurrence': recurrence.toJson(),
    'category': category.toJson(),
  };
}
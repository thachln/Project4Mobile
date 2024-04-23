import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Recurrence/Recurrence.dart';
import 'package:pj4mb/models/User/User.dart';

class Debt{
  final int debtID;
  final User user;
  final Category category;
  final Recurrence recurrence;
  final String Creditor;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;
  final String notes;


  Debt({required this.debtID,required this.user,required this.category,required this.recurrence,required this.Creditor,required this.amount,required this.startDate,required this.endDate,required this.notes});

  factory Debt.fromJson(Map<String, dynamic> json) {
    return Debt(
      debtID: json['debtID'],
      user: User.fromJson(json['user']),
      category: Category.fromJson(json['category']),
      recurrence: Recurrence.fromJson(json['recurrence']),
      Creditor: json['Creditor'],
      amount: json['amount'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'debtID': debtID,
    'user': user.toJson(),
    'category': category.toJson(),
    'recurrence': recurrence.toJson(),
    'Creditor': Creditor,
    'amount': amount,
    'startDate': startDate.toString(),
    'endDate': endDate.toString(),
    'notes': notes,
  };
}
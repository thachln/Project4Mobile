import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Recurrence/Recurrence.dart';
import 'package:pj4mb/models/User/User.dart';

class Debt{
  final int id;
  late int userId;
  final String name;
  final int categoryId;
  final String creditor;
  final double amount;
  final DateTime dueDate;
  final DateTime paidDate;
  final bool isPaid;
  final String notes;


  Debt({required this.id, required this.userId, required this.name, required this.categoryId, required this.creditor, required this.amount, required this.dueDate, required this.paidDate, required this.isPaid, required this.notes});

  factory Debt.fromJson(Map<String, dynamic> json) {
    return Debt(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      categoryId: json['categoryId'],
      creditor: json['creditor'],
      amount: json['amount'],
      dueDate: DateTime.parse(json['dueDate']),
      paidDate: DateTime.parse(json['paidDate']),
      isPaid: json['isPaid'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'categoryId': categoryId,
    'creditor': creditor,
    'amount': amount,
    'dueDate': dueDate.toIso8601String(),
    'paidDate': paidDate.toIso8601String(),
    'isPaid': isPaid,
    'notes': notes,
  };
}
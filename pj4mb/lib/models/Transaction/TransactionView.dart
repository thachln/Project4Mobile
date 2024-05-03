
import 'package:pj4mb/models/Category/CateTypeENum.dart';

class TransactionView{
  final String categoryName;
  final double amount;
  final String cateIcon;

  TransactionView({required this.categoryName, required this.amount, required this.cateIcon});

  factory TransactionView.fromJson(Map<String, dynamic> json){
    return TransactionView(
      categoryName: json['categoryName'],
      amount: json['amount'],
      cateIcon: json['cateIcon']
    );
  }

  Map<String, dynamic> toJson() => {
    'categoryName': categoryName,
    'amount': amount,
    'cateIcon': cateIcon
  };
}


class TransactionData{
  final String categoryName;
	final String cateIcon;
	final double amount;
	final String Type;
	final double totalAmount;

  TransactionData({required this.categoryName, required this.cateIcon, required this.amount, required this.Type, required this.totalAmount});

  factory TransactionData.fromJson(Map<String, dynamic> json){
    return TransactionData(
      categoryName: json['categoryName'],
      cateIcon: json['cateIcon'],
      amount: json['amount'],
      Type: json['type'],
      totalAmount: json['totalAmount']
    );
  }

  Map<String, dynamic> toJson() => {
    'categoryName': categoryName,
    'cateIcon': cateIcon,
    'amount': amount,
    'type': Type,
    'totalAmount': totalAmount
  };
}

class TransactionReport{
  final DateTime transactionDate;
	final double amount;

  TransactionReport({required this.transactionDate, required this.amount});

  factory TransactionReport.fromJson(Map<String, dynamic> json){
    return TransactionReport(
      transactionDate: DateTime.parse(json['transactionDate']),
      amount: json['amount']
    );
  }

  Map<String, dynamic> toJson() => {
    'transactionDate': transactionDate,
    'amount': amount
  };
 
}
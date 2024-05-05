
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
  final int transactionID;
  final String categoryName;
	final String cateIcon;
	final double amount;
	final String Type;
	final double totalAmount;
  final int categoryId;

  TransactionData({required this.transactionID, required this.categoryName, required this.cateIcon, required this.amount, required this.Type, required this.totalAmount, required this.categoryId});

  factory TransactionData.fromJson(Map<String, dynamic> json){
    return TransactionData(
      transactionID: json['transactionID'],
      categoryName: json['categoryName'],
      cateIcon: json['cateIcon'],
      amount: json['amount'],
      Type: json['type'],
      totalAmount: json['totalAmount'],
      categoryId: json['categoryId']
    );
  }

  Map<String, dynamic> toJson() => {
    'transactionID': transactionID,
    'categoryName': categoryName,
    'cateIcon': cateIcon,
    'amount': amount,
    'type': Type,
    'totalAmount': totalAmount,
    'categoryId': categoryId
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
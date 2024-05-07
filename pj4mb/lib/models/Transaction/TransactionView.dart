
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
  final DateTime transactionDate;

  TransactionData({required this.transactionID, required this.categoryName, required this.cateIcon, required this.amount, required this.Type, required this.totalAmount, required this.categoryId, required this.transactionDate});

  factory TransactionData.fromJson(Map<String, dynamic> json){
    return TransactionData(
      transactionID: json['transactionID'],
      categoryName: json['categoryName'],
      cateIcon: json['cateIcon'],
      amount: json['amount'],
      Type: json['type'],
      totalAmount: json['totalAmount'],
      categoryId: json['categoryId'],
      transactionDate: DateTime.parse(json['transactionDate'])
    );
  }

  Map<String, dynamic> toJson() => {
    'transactionID': transactionID,
    'categoryName': categoryName,
    'cateIcon': cateIcon,
    'amount': amount,
    'type': Type,
    'totalAmount': totalAmount,
    'categoryId': categoryId,
    'transactionDate': transactionDate
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

class FindTransactionParam{
  late int userId;
	final DateTime fromDate;
	final DateTime toDate;
	final String type;

  FindTransactionParam({required this.userId, required this.fromDate, required this.toDate, required this.type});

  factory FindTransactionParam.fromJson(Map<String, dynamic> json){
    return FindTransactionParam(
      userId: json['userId'],
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
      type: json['type']
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'fromDate': fromDate.toIso8601String(),
    'toDate': toDate.toIso8601String(),
    'type': type
  };


}
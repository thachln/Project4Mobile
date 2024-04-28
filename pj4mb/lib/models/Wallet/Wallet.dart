import 'package:pj4mb/models/User/User.dart';

class Wallet{
  final int walletID;
  final String walletName;
  late int userId;
  final double balance;
  final String bankName;
  final String bankAccountNum;
  final int walletTypeID;
  final String currency;

  //write the constructor
  Wallet({required this.walletID,required this.walletName,required this.userId,required this.balance,required this.bankName,required this.bankAccountNum,required this.walletTypeID,required this.currency});

  
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      walletID: json['walletId'],
      walletName: json['walletName'],
      userId: json["userId"],
      balance: json['balance'],
      bankName: json['bankName'],
      bankAccountNum: json['bankAccountNum'],
      walletTypeID: json['walletType'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() => {
    'walletID': walletID,
    'walletName': walletName,
    'userId': userId,
    'balance': balance,
    'bankName': bankName,
    'bankAccountNum': bankAccountNum,
    'walletType': walletTypeID,
    'currency': currency,
  };
}
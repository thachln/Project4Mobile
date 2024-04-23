import 'package:pj4mb/models/User/User.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';

class SavingGoal{
  final int savingGoalId;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime startDate;
  final DateTime endDate;
  final User user;
  final Wallet wallet;

  SavingGoal({required this.savingGoalId,required this.name,required this.targetAmount,required this.currentAmount,required this.startDate,required this.endDate,required this.user,required this.wallet});

  factory SavingGoal.fromJson(Map<String, dynamic> json) {
    return SavingGoal(
      savingGoalId: json['savingGoalId'],
      name: json['name'],
      targetAmount: json['targetAmount'],
      currentAmount: json['currentAmount'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      user: User.fromJson(json['user']),
      wallet: Wallet.fromJson(json['wallet']),
    );
  }

  Map<String, dynamic> toJson() => {
    'savingGoalId': savingGoalId,
    'name': name,
    'targetAmount': targetAmount,
    'currentAmount': currentAmount,
    'startDate': startDate.toString(),
    'endDate': endDate.toString(),
    'user': user.toJson(),
    'wallet': wallet.toJson(),
  };
}
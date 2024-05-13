class TransactionWithSaving {
  late int userId;
  final int goalId;

  TransactionWithSaving({required this.userId, required this.goalId});

  factory TransactionWithSaving.fromJson(Map<String, dynamic> json) {
    return TransactionWithSaving(
      userId: json['userId'],
      goalId: json['goalId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'goalId': goalId,
      };
}

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
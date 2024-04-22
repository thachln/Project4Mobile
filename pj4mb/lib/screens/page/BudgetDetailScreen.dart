import 'package:flutter/material.dart';

class BudgetDetailScreen extends StatelessWidget {
  final Map details;

  const BudgetDetailScreen({Key? key, required this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Budget Detail"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(details['icon'] as IconData),
            title: Text(details['name'] as String),
            subtitle: Text("Spent amount: \$${details['spend_amount']}"),
            trailing: Text("\$${details['left_amount']}"),
          ),
          // Thông tin chi tiết khác
        ],
      ),
    );
  }
}
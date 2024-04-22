import 'package:flutter/material.dart';
import 'BudgetDetailScreen.dart';
// Đảm bảo đã import screen chi tiết

class BudgetList extends StatelessWidget {
  final budgetArr = [
    {
      "name": "Auto & Transport",
      "icon": Icons.car_rental,
      "spend_amount": "25.99",
      "total_budget": "400",
      "left_amount": "250.01",
      "color": Colors.green
    },
    {
      "name": "Entertainment",
      "icon": Icons.movie,
      "spend_amount": "50.99",
      "total_budget": "600",
      "left_amount": "300.01",
      "color": Colors.orange
    },
    {
      "name": "Security",
      "icon": Icons.security,
      "spend_amount": "5.99",
      "total_budget": "600",
      "left_amount": "250.01",
      "color": Colors.red
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: budgetArr.length,
      itemBuilder: (context, index) {
        var bObj = budgetArr[index];
        return ListTile(
          leading: Icon(bObj['icon'] as IconData),
          title: Text(bObj['name'] as String),
          subtitle: Text("Spent: \$${bObj['spend_amount']}"),
          trailing: Text("\$${bObj['left_amount']}"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BudgetDetailScreen(details: bObj),
              ),
            );
          },
        );
      },
    );
  }
}
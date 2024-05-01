import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';

class ListTop5NewTransaction extends StatelessWidget {
  const ListTop5NewTransaction({super.key, required this.listTransactionTop5});
  final List<TransactionView> listTransactionTop5;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listTransactionTop5.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          TransactionView transaction = listTransactionTop5[index];
          return ListTile(
            leading: Image.asset("assets/icon/${transaction.cateIcon}"),
            title: Text(transaction.categoryName),
            trailing: Text(transaction.amount.toString()),
          );
        });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pj4mb/models/Category/CateTypeENum.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';

class HistoryWidgets extends StatelessWidget {
  const HistoryWidgets({super.key, required this.listTransaction});
  final List<TransactionData> listTransaction;
  @override
  Widget build(BuildContext context) {
    
    TransactionData Income = listTransaction.firstWhere((element) => element.Type == "INCOME",orElse: () => new TransactionData(categoryName: '1', cateIcon: '1', amount: 0, Type: 'INCOME', totalAmount: 0));
    TransactionData Expense = listTransaction.firstWhere((element) => element.Type == "EXPENSE",orElse: () => new TransactionData(categoryName: '1', cateIcon: '1', amount: 0, Type: 'EXPENSE', totalAmount: 0));
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(('Tiền vào')),
              Expanded(
                  child: Text(
                Income.totalAmount.toString(),
                textAlign: TextAlign.right,
              ))
            ],
          ),
          Row(
            children: [
              Text(('Tiền ra')),
              Expanded(
                  child: Text(
                Expense.totalAmount.toString(),
                textAlign: TextAlign.right,
              ))
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Text(
                (Income.totalAmount - Expense.totalAmount).toString(),
                textAlign: TextAlign.right,
              ))
            ],
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                        itemCount: listTransaction.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          TransactionData trans = listTransaction[index];
                          return ListTile(
                            leading: Image.asset("assets/icon/${trans.cateIcon}"),
                            title: Text(trans.categoryName),
                            trailing: trans.Type == "INCOME" 
                            ? Text(trans.amount.toString(),style: TextStyle(color: Colors.green[400]),)
                            : Text(trans.amount.toString(),style: TextStyle(color: Colors.red[400])),
                          );
                        })
            ),
          ),
          
        ],
      ),
    );
  }
}

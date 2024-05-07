import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pj4mb/models/Category/CateTypeENum.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Transaction/Transaction.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';
import 'package:pj4mb/screens/Transaction/UpdateTransaction.dart';
import 'package:pj4mb/services/Category_service.dart';
import 'package:pj4mb/services/Transacsion_service.dart';

class HistoryWidgets extends StatelessWidget {
  const HistoryWidgets(
      {super.key, required this.listTransaction, required this.onSave});
  final List<TransactionData> listTransaction;
  final void Function(dynamic value) onSave;
  @override
  Widget build(BuildContext context) {
    TransactionData Income = listTransaction.firstWhere(
        (element) => element.Type == "INCOME",
        orElse: () => new TransactionData(
            transactionID: 0,
            categoryName: '1',
            cateIcon: '1',
            amount: 0,
            Type: 'INCOME',
            totalAmount: 0,
            categoryId: 0, transactionDate: DateTime.now()));
    TransactionData Expense = listTransaction.firstWhere(
        (element) => element.Type == "EXPENSE",
        orElse: () => new TransactionData(
          transactionID: 0,
            categoryName: '1',
            cateIcon: '1',
            amount: 0,
            Type: 'EXPENSE',
            totalAmount: 0,
            categoryId: 0, transactionDate: DateTime.now()));
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
          Divider(),
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
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {       
                          Transaction newTrans  = await TransactionService().GetTransactionById(trans.transactionID);   
                          CategoryResponse category = await CategoryService().GetCategoryWithId(trans.categoryId);       
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateTransactionPage( trans: newTrans, cate: category,          
                                      )));
                          if (result) {
                            onSave(result);
                          }
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: Image.asset("assets/icon/${trans.cateIcon}"),
                          title: Text(trans.categoryName),
                          trailing: trans.Type == "INCOME"
                              ? Text(
                                  trans.amount.toString(),
                                  style: TextStyle(color: Colors.green[400]),
                                )
                              : Text(trans.amount.toString(),
                                  style: TextStyle(color: Colors.red[400])),
                        ),
                      ),
                    ],
                  );
                }),
          )),
        ],
      ),
    );
  }
}

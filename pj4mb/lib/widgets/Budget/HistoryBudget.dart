import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Category/CateTypeENum.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Transaction/Transaction.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';
import 'package:pj4mb/models/Wallet/Wallet.dart';
import 'package:pj4mb/screens/Transaction/UpdateTransaction.dart';
import 'package:pj4mb/services/Category_service.dart';
import 'package:pj4mb/services/Transacsion_service.dart';
import 'package:pj4mb/services/Wallet_service.dart';

class HistoryBudget extends StatelessWidget {
  const HistoryBudget(
      {super.key, required this.listTransaction, required this.onSave});
  final List<TransactionData> listTransaction;
  final void Function(dynamic value) onSave;
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###");

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
                          Wallet wallet = await WalletService().GetWalletById(newTrans.walletId);    
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateTransactionPage( trans: newTrans, cate: category, walletTypeCurrent: wallet.walletTypeID,          
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
                                  formatter.format(trans.amount),
                                  style: TextStyle(color: Colors.green[400]),
                                )
                              : Text(formatter.format(trans.amount),
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

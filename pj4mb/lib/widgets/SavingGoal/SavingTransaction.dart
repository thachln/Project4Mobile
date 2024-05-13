import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Transaction/Transaction.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';
import 'package:pj4mb/screens/Transaction/UpdateTransaction.dart';
import 'package:pj4mb/services/Category_service.dart';
import 'package:pj4mb/services/Transacsion_service.dart';

class SavingTransaction extends StatefulWidget {
  const SavingTransaction({super.key, required this.listTransaction, required this.onSave});
  final List<TransactionData> listTransaction;
  final void Function(dynamic value) onSave;
  @override
  State<SavingTransaction> createState() => _SavingTransactionState();
}

class _SavingTransactionState extends State<SavingTransaction> {
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
              child: Container(
            child: ListView.builder(
                itemCount: widget.listTransaction.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  TransactionData trans = widget.listTransaction[index];
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
                            widget.onSave(result);
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
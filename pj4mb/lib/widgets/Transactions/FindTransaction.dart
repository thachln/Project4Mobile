import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';

class FindListTransaction extends StatelessWidget {
  const FindListTransaction({super.key, required this.transactionData});
  final List<TransactionData> transactionData;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###");
    return Expanded(
              child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            child: ListView.builder(
                itemCount: transactionData.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  TransactionData trans = transactionData[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {       
                          
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: Image.asset("assets/icon/${trans.cateIcon}"),
                          subtitle: Text(DateFormat('dd-MM-yyyy').format(trans.transactionDate)),
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
                       SizedBox(height: 10,),
                    ],
                   
                  );
                }),
          ));
  }
}
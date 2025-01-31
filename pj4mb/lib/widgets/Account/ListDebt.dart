import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Debt/Debt.dart';
import 'package:pj4mb/models/Response.dart';
import 'package:pj4mb/screens/Debt/UpdateDebt.dart';
import 'package:pj4mb/services/Debt_service.dart';

class ListDebt extends StatefulWidget {
  const ListDebt(
      {super.key, required this.onSave, required this.listDebt,required this.flag});
  final List<Debt> listDebt;
  final void Function(dynamic value) onSave;
  final flag;
  @override
  State<ListDebt> createState() => _ListDebtState();
}

class _ListDebtState extends State<ListDebt> {
  final formatter = NumberFormat("#,###");
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: [ListView.builder(
            itemCount: widget.listDebt.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Debt debt = widget.listDebt[index];
              return Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (debt.isPaid == false) {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateDebtPage(
                                      debt: debt,
                                      flag: 0,
                                    )));
                        if (result) {
                          widget.onSave(result);
                        }
                      } else {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateDebtPage(
                                      debt: debt,
                                      flag: 1,
                                    )));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all( 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                          leading: Icon(Icons.account_balance_wallet_outlined),
                          title: Text(debt.name),
                          subtitle: debt.isPaid == false
                              ? Text(debt.creditor +
                                  " - DueDate: " +
                                  DateFormat('dd-MM-yyyy').format(debt.dueDate))
                              : Text(debt.creditor +
                                  " - PaidDate: " +
                                  DateFormat('dd-MM-yyyy').format(debt.paidDate!)),
                          trailing: debt.isPaid == false
                              ? Column(mainAxisSize: MainAxisSize.min, children: [
                                  SizedBox(
                                      width: 130,
                                      height: 20,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Confirm?'),
                                                content: Text('Are you sure ?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      debt.isPaid = true;
                                                      debt.paidDate =
                                                          DateTime.now();
                                                      var result =
                                                          await DebthService()
                                                              .UpdateDebt(debt);
                                                      if (result.status == 200) {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Information'),
                                                              content: Text(
                                                                  'Update success!'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                        context,
                                                                        true);
                                                                    Navigator.pop(
                                                                        context,
                                                                        true);
                                                                    widget.onSave(
                                                                        result);
                                                                  },
                                                                  child: Text('OK'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Information'),
                                                              content: Text(
                                                                  'Update fail!'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                        context,
                                                                        true);
                                                                    Navigator.pop(
                                                                        context,
                                                                        true);
                                                                  },
                                                                  child: Text('OK'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                    child: Text('OK'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Cancle'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Text('Mark as paid'),
                                      )),
                                  SizedBox(width: 10),
                                  Text(formatter.format(debt.amount) + " VND"),
                                ])
                              : Text(formatter.format(debt.amount) + " VND")),
                    ),
                  )
                ],
              );
            }),
        ]
      ),
    );
  }
}

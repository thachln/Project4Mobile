import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/TransactionRecurrence/TransRecuResponce.dart';
import 'package:pj4mb/models/TransactionRecurrence/TransactionRecurrence.dart';
import 'package:pj4mb/screens/Transaction_Recurrence/UpdateTransactionRecurrence.dart';
import 'package:pj4mb/services/TransactionRecurrence_service.dart';

class TranRecuList extends StatelessWidget {
  const TranRecuList({super.key, required this.listTranRecu, required this.onSave});
  final List<TransRecuResponce> listTranRecu;
  final void Function(dynamic value) onSave;
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###");
    return Container(
            child: ListView.builder(
                itemCount: listTranRecu.length,
               padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  TransRecuResponce tranRecu = listTranRecu[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {        
                          TransactionRecurrence transaction = await TransactionRecurrence_Service().findTransById(tranRecu.transactionRecurringId);
                       
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateTransactionRecurrencePage(transactionRecurrence: transaction,
                                        
                                      )));
                          if(result == true){
                             onSave(result);
                          }
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.all(5),
                          leading: Image.asset("assets/icon/${tranRecu.category.icon.path}"),
                          subtitle: Text(tranRecu.recurrence.frequency + " - Repeat at " + DateFormat('dd-MM-yyyy').format(tranRecu.recurrence.dueDate) ),
                          title: Text(tranRecu.category.name),
                          trailing: Text(formatter.format(tranRecu.amount) + " VND"),
                        ),
                      ),
                    ],
                  );
                }),
          );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Bill/Bill.dart';
import 'package:pj4mb/models/Bill/BillResponse.dart';
import 'package:pj4mb/screens/Bill/UpdateBill.dart';
import 'package:pj4mb/services/Bill_service.dart';

class BillList extends StatelessWidget {
  const BillList({super.key, required this.listBill, required this.onSave});
  final List<BillResponse> listBill;
  final void Function(dynamic value) onSave;
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###");
    return Expanded(
            child: ListView.builder(
                itemCount: listBill.length,
               padding: const EdgeInsets.all(8),
                
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  BillResponse bills = listBill[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {       
                           print(bills.billId);
                          Bill bill = await BillService().findBillById(bills.billId);
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateBillPage(
                                        bill: bill,
                                      )));
                          if(result == true){
                             onSave(result);
                          }
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.all(5),
                          leading: Image.asset("assets/icon/${bills.category.icon.path}"),
                          subtitle: Text(bills.recurrence.frequency + " - Repeat at " + DateFormat('dd-MM-yyyy').format(bills.recurrence.dueDate) ),
                          title: Text(bills.category.name),
                          trailing: Text(formatter.format(bills.amount) + " VND"),
                        ),
                      ),
                    ],
                  );
                }),
          );
  }
}
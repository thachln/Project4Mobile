import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Category/CateTypeENum.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';
import 'package:pj4mb/services/Transacsion_service.dart';
import 'package:pj4mb/widgets/Transactions/FindTransaction.dart';

class FindTransaction extends StatefulWidget {
  const FindTransaction({super.key});

  @override
  State<FindTransaction> createState() => _FindTransactionState();
}

class _FindTransactionState extends State<FindTransaction> {
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  CateTypeENum selectedCateType = CateTypeENum.INCOME;
  late List<TransactionData> listFindTransaction;
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedFromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedFromDate) {
      setState(() {
        selectedFromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedToDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedToDate) {
      setState(() {
        selectedToDate = picked;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    listFindTransaction = [];
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<CateTypeENum>> dropdownItems = CateTypeENum.values
        .map((frequencyType) => DropdownMenuItem<CateTypeENum>(
              value: frequencyType,
              child: Text(frequencyType.toString().split('.').last),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Find Transaction'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month_sharp),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: InkWell(
                onTap: () async {
                  await _selectFromDate(context);
                },
                child: Text("FromDate: " +
                    DateFormat('dd-MM-yyyy').format(selectedFromDate)),
              ))
            ],
          ),
          Row(
            children: [
              Icon(Icons.calendar_month_sharp),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: InkWell(
                onTap: () async {
                  await _selectToDate(context);
                },
                child: Text("ToDate: " +
                    DateFormat('dd-MM-yyyy').format(selectedToDate)),
              ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Text('Frequency: '),
                DropdownButton<CateTypeENum>(
                  value: selectedCateType,
                  onChanged: (CateTypeENum? newValue) {
                    setState(() {
                      selectedCateType = newValue!;
                    });
                  },
                  items: dropdownItems,
                )
              ],
            ),
          ),
          ElevatedButton(onPressed: () async {
            FindTransactionParam param = new FindTransactionParam(userId: 0, fromDate: selectedFromDate, toDate: selectedToDate, type: selectedCateType.name);     
            var result = await TransactionService().FindTransction(param);
            setState(() {
              listFindTransaction = result;
            });
          }, child: Text('Find Transaction')),
          FindListTransaction(transactionData: listFindTransaction)
        ],
      ),
    );
  }
}

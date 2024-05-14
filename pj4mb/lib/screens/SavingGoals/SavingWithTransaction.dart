import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Budget/Budget.dart';
import 'package:pj4mb/models/Budget/ParamBudget.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/SavingGoal/SavingGoal.dart';
import 'package:pj4mb/models/SavingGoal/TransactionWithSaving.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';
import 'package:pj4mb/screens/Budget/UpdateBudgetPage.dart';
import 'package:pj4mb/screens/SavingGoals/UpdateSaving.dart';
import 'package:pj4mb/services/Budget_service.dart';
import 'package:pj4mb/services/Category_service.dart';
import 'package:pj4mb/services/SavingGoal_service.dart';
import 'package:pj4mb/services/Transacsion_service.dart';
import 'package:pj4mb/widgets/Budget/HistoryBudget.dart';
import 'package:pj4mb/widgets/Transactions/History.dart';

class SavingWithTransactionPage extends StatefulWidget {
  const SavingWithTransactionPage({super.key, required this.saving});
  final SavingGoal saving;
  @override
  State<SavingWithTransactionPage> createState() =>
      _SavingWithTransactionPageState();
}

class _SavingWithTransactionPageState extends State<SavingWithTransactionPage> {
  late double progress;
  late Future<List<TransactionData>> transactions;
  late TransactionWithSaving param;
  //late Budget budgetData;
  late int changed = 0;
  late SavingGoal savingData;
  @override
  void initState() {
    //loadData();
    super.initState();
    param = TransactionWithSaving(userId: 0, goalId: widget.saving.id);

    transactions = SavingGoalService().GetTransactionWithSaving(param);
    progress =
        ((widget.saving.currentAmount * 100) / widget.saving.targetAmount) /
            100;
    savingData = widget.saving;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###");
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction With Saving'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (changed == 0) {
                Navigator.pop(context, false);
              } else {
                Navigator.pop(context, true);
              }
            }),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              print(1);
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateSavingPage(
                    saving: savingData,
                  ),
                ),
              );
              if (result) {
                changed = 1;
                loadDataReturn();
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  savingData.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${formatter.format(savingData.targetAmount)}đ'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Money Start: ' + formatter.format(savingData.currentAmount) + 'đ'),
                Text(
                  
                    'Remaining: ${formatter.format(savingData.targetAmount - savingData.currentAmount)}đ'),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: FutureBuilder<List<TransactionData>>(
              future: transactions,
              builder: (BuildContext context,
                  AsyncSnapshot<List<TransactionData>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return HistoryBudget(
                      listTransaction: snapshot.data!,
                      onSave: (value) {
                        setState(() {
                          changed = 1;
                          transactions = SavingGoalService()
                              .GetTransactionWithSaving(param);
                          //loadDataReturn();
                        });
                      });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadDataReturn() async {
    transactions = SavingGoalService().GetTransactionWithSaving(param);
    var savingNewData = await SavingGoalService().GetSavingWithSavingID(param);
    setState(() {
      savingData = savingNewData.first;
      progress =
        ((savingData.currentAmount * 100) / savingData.targetAmount) /
            100;
    });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Budget/Budget.dart';
import 'package:pj4mb/models/Budget/ParamBudget.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';
import 'package:pj4mb/services/Budget_service.dart';
import 'package:pj4mb/services/Category_service.dart';
import 'package:pj4mb/services/Transacsion_service.dart';
import 'package:pj4mb/widgets/Budget/HistoryBudget.dart';
import 'package:pj4mb/widgets/Transactions/History.dart';

class BudgetWithTransactionPage extends StatefulWidget {
  const BudgetWithTransactionPage(
      {super.key, required this.budget, required this.category});
  final Budget budget;
  final CategoryResponse category;
  @override
  State<BudgetWithTransactionPage> createState() =>
      _BudgetWithTransactionPageState();
}

class _BudgetWithTransactionPageState extends State<BudgetWithTransactionPage> {
  late double progress;
  late Future<List<TransactionData>> transactions;
  @override
  void initState() {
    //loadData();
    super.initState();
    ParamPudget param = new ParamPudget(
        userId: 0,
        fromDate: widget.budget.period_start,
        toDate: widget.budget.period_end);
    param.categoryId = widget.budget.categoryId;

    transactions = Budget_Service().GetTransactionWithBudget(param);
    progress =
        ((widget.budget.amount * 100) / widget.budget.threshold_amount) / 100;
  }

  void loadData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction With Budget'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.category.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${widget.budget.threshold_amount}đ'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                  'Còn lại: ${widget.budget.threshold_amount - widget.budget.amount}đ'),
            ],
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
                      listTransaction: snapshot.data!, onSave: (value) {});
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

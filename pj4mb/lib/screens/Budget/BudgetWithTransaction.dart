import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Budget/Budget.dart';
import 'package:pj4mb/models/Budget/ParamBudget.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';
import 'package:pj4mb/screens/Budget/UpdateBudgetPage.dart';
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
  late BugetParam param;
  late Budget budgetData;
  late CategoryResponse categoryData;
  late int changed = 0;
  @override
  void initState() {
    //loadData();
    super.initState();
    param = new BugetParam(
        userId: 0,
        fromDate: widget.budget.period_start,
        toDate: widget.budget.period_end);
    param.categoryId = widget.budget.categoryId;

    transactions = Budget_Service().GetTransactionWithBudget(param);
    progress =
        ((widget.budget.amount * 100) / widget.budget.threshold_amount) / 100;

    budgetData = widget.budget;
    categoryData = widget.category;
  }

  void loadData() async {}

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###");
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction With Budget'),
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
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateBudgetPage(
                    budget: budgetData,
                    cate: categoryData,
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
                  categoryData.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${formatter.format(budgetData.threshold_amount)}đ'),
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                    'Remaining: ${formatter.format(budgetData.threshold_amount - budgetData.amount)}đ'),
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
                          transactions =
                              Budget_Service().GetTransactionWithBudget(param);
                          loadDataReturn();
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
    var newTransactions =
        await Budget_Service().GetTransactionWithBudget(param);
    var newBudgetData =
        await Budget_Service().GetBudgetById(widget.budget.budgetId);
    var newCategoryData =
        await CategoryService().GetCategoryWithId(widget.category.categoryID);

    // Sau khi hoàn tất việc lấy dữ liệu, cập nhật trạng thái
    setState(() {
      transactions = Future.value(
          newTransactions); // Chú ý sử dụng Future.value để gán giá trị Future mới
      budgetData = newBudgetData;
      categoryData = newCategoryData;
      progress =
        ((budgetData.amount * 100) / budgetData.threshold_amount) / 100;
    });
  }
}

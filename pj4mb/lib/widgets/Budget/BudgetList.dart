import 'package:flutter/material.dart';
import 'package:pj4mb/models/Budget/Budget.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/screens/Budget/UpdateBudgetPage.dart';
import 'package:pj4mb/services/Budget_service.dart';
import 'package:pj4mb/services/Category_service.dart';
// Đảm bảo đã import screen chi tiết

class BudgetList extends StatelessWidget {
  const BudgetList({Key? key, required this.listBudget, required this.onSave})
      : super(key: key);
  final List<BudgetResponse> listBudget;
  final void Function(dynamic value) onSave;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: listBudget.length,
      itemBuilder: (context, index) {
        var budget = listBudget[index];
        double progress =
            ((budget.amount * 100) / budget.thresholdAmount) / 100;
        return GestureDetector(
          onTap: () async {
            Budget budgetId = await Budget_Service().GetBudgetById(budget.budgetId);
            CategoryResponse category = await CategoryService().GetCategoryWithId(budgetId.categoryId);
            var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateBudgetPage(budget: budgetId, cate: category,)));
            if(result)
            {
              onSave(result);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    budget.categoryName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${budget.thresholdAmount}đ'),
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
                  Text('Còn lại: ${budget.thresholdAmount - budget.amount}đ'),
                ],
              ),
              SizedBox(
                height: 25,
              )
            ],
          ),
        );
      },
    );
  }
}

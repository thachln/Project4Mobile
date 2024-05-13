import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/models/SavingGoal/SavingGoal.dart';
import 'package:pj4mb/screens/SavingGoals/SavingWithTransaction.dart';
import 'package:pj4mb/services/Category_service.dart';

class GoalList extends StatefulWidget {
  const GoalList({super.key, required this.listGoal, required this.onSave});
  final List<SavingGoal> listGoal;
  final void Function(dynamic value) onSave;

  @override
  State<GoalList> createState() => _GoalListState();
}

class _GoalListState extends State<GoalList> {
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###");
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: widget.listGoal.length,
      itemBuilder: (context, index) {
        var goal = widget.listGoal[index];
        double progress =
            ((goal.currentAmount * 100) / goal.targetAmount) / 100;
        return Container(
          
          child: GestureDetector(
            onTap: () async {
  
              var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => SavingWithTransactionPage(saving: goal,)));
              // var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateBudgetPage(budget: budgetId, cate: category,)));
              if(result)
              {
                widget.onSave(result);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      goal.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${formatter.format(goal.targetAmount)}đ'),
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
                    Text('Còn lại: ${formatter.format(goal.targetAmount - goal.currentAmount)}đ'),
                  ],
                ),
                SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
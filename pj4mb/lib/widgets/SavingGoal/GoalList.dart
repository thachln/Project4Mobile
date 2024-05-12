import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/SavingGoal/SavingGoal.dart';

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
    return Container(
            child: ListView.builder(
                itemCount: widget.listGoal.length,
               padding: const EdgeInsets.all(8),
                
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  SavingGoal goal = widget.listGoal[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {       
                          
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.all(5),
                          
                          subtitle: Text('' ),
                          title: Text(''),
                          trailing: Text('') ,
                        ),
                      ),
                    ],
                  );
                }),
          );
  }
}
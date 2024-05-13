import 'package:flutter/material.dart';
import 'package:pj4mb/models/SavingGoal/SavingGoal.dart';
import 'package:pj4mb/screens/SavingGoals/AddSaving.dart';
import 'package:pj4mb/services/SavingGoal_service.dart';
import 'package:pj4mb/widgets/SavingGoal/GoalList.dart';

class SavingGoalPage extends StatefulWidget {
  const SavingGoalPage({super.key});

  @override
  State<SavingGoalPage> createState() => _SavingGoalPageState();
}

class _SavingGoalPageState extends State<SavingGoalPage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  late Future<List<SavingGoal>> savingWorking;
  late Future<List<SavingGoal>> savingFull;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    savingWorking = SavingGoalService().findWorkingByUserId();
    savingFull = SavingGoalService().findFinishedByUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saving Goal'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabBar(
              controller: _tabController,
              // Đặt index của tab hiện tại
              onTap: (index) {},
              tabs: [
                Tab(text: 'Working'),
                Tab(text: 'Full'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  FutureBuilder<List<SavingGoal>>(
                    future: savingWorking,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<SavingGoal>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        if (snapshot.data!.isEmpty) {
                          return Center(child: Text('No data'));
                        }
                        return GoalList(
                          onSave: (value) {
                            setState(() {
                              savingWorking =
                                  SavingGoalService().findWorkingByUserId();
                              savingFull =
                                  SavingGoalService().findFinishedByUserId();
                            });
                          },
                          listGoal: snapshot.data!,
                        );
                      }
                    },
                  ),
                  FutureBuilder<List<SavingGoal>>(
                    future: savingFull,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<SavingGoal>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        if (snapshot.data!.isEmpty) {
                          return Center(child: Text('No data'));
                        }
                        return GoalList(
                          onSave: (value) {
                            setState(() {
                              savingWorking =
                                  SavingGoalService().findWorkingByUserId();
                              savingFull =
                                  SavingGoalService().findFinishedByUserId();
                            });
                          },
                          listGoal: snapshot.data!,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            var result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddSavingPage()));
            if (result) {
              setState(() {
                savingWorking = SavingGoalService().findWorkingByUserId();
                savingFull = SavingGoalService().findFinishedByUserId();
              });
            }
          },
          backgroundColor: Colors.pink[200],
          mini: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
    );
  }
}

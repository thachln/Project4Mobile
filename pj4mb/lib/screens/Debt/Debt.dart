import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/screens/Debt/AddDebt.dart';
import 'package:pj4mb/widgets/Account/ListDebt.dart';

class DebtPage extends StatefulWidget {
  const DebtPage({super.key});

  @override
  State<DebtPage> createState() => _DebtPageState();
}

class _DebtPageState extends State<DebtPage> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Debt'),),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(bottom: 200),
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
                    Tab(text: 'Cần thu'),
                    Tab(text: 'Cần trả'),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 120,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Container(child: ListDebt()),
                      Container(
                        child: ListDebt(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          mini: true,
          child: Icon(Icons.add),
          onPressed: () async {
            var result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddDebtPage()));
            if (result) {
              setState(() {
               
              });
            }
          },
          backgroundColor: Colors.pink[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
          );
  }
}

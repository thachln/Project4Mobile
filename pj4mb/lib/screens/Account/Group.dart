import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/widgets/Account/ListGroup.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Group')),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Khoản chi'),
                  Tab(text: 'Khoản thu'),
                  Tab(text: 'Vay/Nợ'),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListGroup(onSave: (value) => Navigator.pop(context, value)),
                    ListGroup(onSave: (value) => Navigator.pop(context, value)),
                    ListGroup(onSave: (value) => Navigator.pop(context, value)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
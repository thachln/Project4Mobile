import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/widgets/Account/ListGroup.dart';
import 'package:pj4mb/widgets/Transactions/ListGroupAdd.dart';

class TransactionAdd_GroupPage extends StatefulWidget {
  const TransactionAdd_GroupPage({super.key});

  @override
  State<TransactionAdd_GroupPage> createState() => _TransactionAdd_GroupPageState();
}

class _TransactionAdd_GroupPageState extends State<TransactionAdd_GroupPage> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    
    _tabController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Group'),),
      body: SingleChildScrollView(
        
          child: Container(
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
                        onTap: (index) {
                          
                        },
                        tabs: [
                          Tab(text: 'Khoản chi'),
                          Tab(text: 'Khoản thu'),
                          Tab(text: 'Vay/Nợ'),
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: TabBarView(
                          // Đặt controller cho TabBarView để đồng bộ với TabBar
                          controller: _tabController,
                          children: [
                            // Nội dung của tab thứ nhất (Tháng trước)
                            Container(
                              child: ListGroupAdd()
                            ),
                            // Nội dung của tab thứ hai (Tháng này)
                            Container(
                              child: ListGroupAdd(),
                            ),
                            // Nội dung của tab thứ ba (Tháng tương lai)
                            Container(
                              child: ListGroupAdd(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              
      )
    );
  }
}
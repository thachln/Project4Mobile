import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pj4mb/widgets/Transactions/History.dart';

class TransactionsScreen extends StatefulWidget {
  
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo TabController với this vì nó là TickerProvider
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // Giải phóng TabController khi State bị loại bỏ
    _tabController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Số dư',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '1,000,000đ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.search),
                            tooltip: 'Tìm kiếm',
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_horiz),
                            tooltip: 'More',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
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
                        Tab(text: 'Tháng trước'),
                        Tab(text: 'Tháng này'),
                        Tab(text: 'Tháng tương lai'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        // Đặt controller cho TabBarView để đồng bộ với TabBar
                        controller: _tabController,
                        children: [
                          // Nội dung của tab thứ nhất (Tháng trước)
                          Container(
                            child: HistoryWidgets()
                          ),
                          // Nội dung của tab thứ hai (Tháng này)
                          Container(
                            child: HistoryWidgets(),
                          ),
                          // Nội dung của tab thứ ba (Tháng tương lai)
                          Container(
                            child: HistoryWidgets(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
    );
  }
}

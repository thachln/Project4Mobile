import 'package:flutter/material.dart';
import 'package:pj4mb/screens/page/AddBudgetPage.dart';
import 'package:pj4mb/screens/page/BudgetList.dart';
import '../aset/custom_arc_180_painter.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // Biểu đồ cho từng tháng
  List<Widget> budgetCharts = [
    // Biểu đồ cho tháng trước
    CustomPaint(
      painter: CustomArc180Painter(
        drwArcs: [
          ArcValueModel(color: Colors.green, value: 20),
          ArcValueModel(color: Colors.orange, value: 30),
          ArcValueModel(color: Colors.red, value: 25),
        ],
        end: 50,
        width: 12,
        bgWidth: 8,
      ),
    ),
    // Biểu đồ cho tháng này
    CustomPaint(
      painter: CustomArc180Painter(
        drwArcs: [
          ArcValueModel(color: Colors.green, value: 15),
          ArcValueModel(color: Colors.orange, value: 35),
          ArcValueModel(color: Colors.red, value: 50),
        ],
        end: 50,
        width: 12,
        bgWidth: 8,
      ),
    ),

    // Biểu đồ cho tháng tương lai
    CustomPaint(
      painter: CustomArc180Painter(
        drwArcs: [
          ArcValueModel(color: Colors.green, value: 30),
          ArcValueModel(color: Colors.orange, value: 40),
          ArcValueModel(color: Colors.red, value: 30),
        ],
        end: 50,
        width: 12,
        bgWidth: 8,
      ),
    ),
  ];

  List<Widget> budgetInfo = [
    Column(
      children: [
        Text(
          "\$100,00",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          "of \$1,0000 budget",
          style: TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    ), // Tháng trước
    Column(
      children: [
        Text(
          "\$200,00",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          "of \$2,0000 budget",
          style: TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    ), // Tháng này
    Column(
      children: [
        Text(
          "\$300,00",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          "of \$3,0000 budget",
          style: TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    ), // Tháng tương lai
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 35, right: 10),
            child: Row(
              children: [
                Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddBudgetPage()),
                    );
                  },
                  icon: Ink(
                    decoration: const ShapeDecoration(
                      color: Colors.red, // Bạn có thể thay màu này.
                      shape: CircleBorder(),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: media.size.width * 0.5,
                height: media.size.width * 0.30,
                child: budgetCharts[_tabController!.index],
              ),
              budgetInfo[_tabController!.index],
            ],
          ),
          const SizedBox(
            height: 40,
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
                    tabs: [
                      Tab(text: 'Tháng trước'),
                      Tab(text: 'Tháng này'),
                      Tab(text: 'Tháng tương lai'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        BudgetList(),
                        BudgetList(),
                        BudgetList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

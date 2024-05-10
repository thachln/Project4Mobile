import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pj4mb/models/Debt/ReportDebt.dart';
import 'package:pj4mb/services/Debt_service.dart';

class ReportDebt extends StatefulWidget {
  const ReportDebt({super.key});

  @override
  State<ReportDebt> createState() => _ReportDebtState();
}

class _ReportDebtState extends State<ReportDebt> {
  late Future<List<ReportDebtData>> reportDebtData;
  late int totalNumber;
  @override
  void initState() {
    super.initState();
    reportDebtData = DebthService().getReportDebt();
  }

  int getTotalNumber(List<ReportDebtData> data) {
    int total = 0;
    for (var item in data) {
      total += item.number;
    }
    return total;
  }
  List<Color> colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.indigo,
      Colors.pink
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Debt'),
      ),
      body: FutureBuilder<List<ReportDebtData>>(
        future: reportDebtData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<ReportDebtData> data = snapshot.data!;
            totalNumber = getTotalNumber(data);
            return Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1.23,
                    child: Card(
                      color: Colors.white,
                      child: PieChart(
                        PieChartData(
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: getSectionsFromData(data),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                          itemCount: snapshot.data!.length,                
                          itemBuilder: (context, index) {
                            ReportDebtData debtData = snapshot.data![index];
                            return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {},
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: ListTile(
                                          leading: Icon(
                                              Icons.account_balance_wallet_outlined),
                                          title: Text(debtData.name,style: TextStyle(color: colors[index % colors.length],fontFamily: 'RobotoVietnamese'),),                   
                                          trailing: Text(debtData.number.toString(),style: TextStyle(color: colors[index % colors.length]),)),
                                    ),
                                  ),
                                  SizedBox(height: 6)
                                ],
                              );
                          }),
                  ),
                ],
              )
            ;
          } else {
            return Text("Không có dữ liệu.");
          }
        },
      ),
    );
  }

  List<PieChartSectionData> getSectionsFromData(List<ReportDebtData> data) {

    return List.generate(data.length, (index) {
      final item = data[index];
      double percentage = item.number.toDouble() * 100 / totalNumber;
      String twoDigitsPercentage = percentage.toStringAsFixed(2);
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: double.parse(twoDigitsPercentage),
        title: '${double.parse(twoDigitsPercentage)}%',
        radius: 50.0,
        titleStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    });
  }
}

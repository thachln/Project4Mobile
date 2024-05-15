import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Budget/ListDateTime.dart';
import 'package:pj4mb/models/Budget/ParamBudget.dart';
import 'package:pj4mb/models/Debt/Debt.dart';
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
  late ListDateTime listDateTime;
  late DateTime fromDate;
  late DateTime toDate;
  List<DetailReportDebtData> dataDetail = [];

  @override
  void initState() {
    super.initState();
    listDateTime = getFullDays(DateTime.now());
    ParamPudget param = new ParamPudget(
        userId: 0,
        fromDate: listDateTime.startOfMonth,
        toDate: listDateTime.endOfMonth);
    reportDebtData = DebthService().getReportDebt(param);
    fromDate = listDateTime.startOfMonth;
    toDate = listDateTime.endOfMonth;
    getDataDetail();
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
    Colors.pink,
    Colors.pink,
    Colors.yellow
  ];

  void getDataDetail() async {
    dataDetail ??= [];
    for (int i = 0; i <= 7; i++) {
      GetDetailReportDebtParam param = GetDetailReportDebtParam(
          userId: 0, fromDate: fromDate, toDate: toDate, index: i);
      var result = await DebthService().getDetailReport(param);
      setState(() {
        dataDetail += result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _selectFromDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != fromDate) {
        setState(() {
          fromDate = picked;
        });
      }
    }

    Future<void> _selectToDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: toDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != toDate) {
        setState(() {
          toDate = picked;
        });
      }
    }

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
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 10),
                          width: 130,
                          height: 50,
                          child: Row(children: [
                            Text('From: '),
                            Expanded(
                                child: InkWell(
                              onTap: () async {
                                await _selectFromDate(context);
                              },
                              child: Text(
                                  DateFormat('dd-MM-yyyy').format(fromDate)),
                            ))
                          ])),
                      Container(
                          padding: EdgeInsets.only(left: 10),
                          width: 130,
                          height: 50,
                          child: Row(children: [
                            Text('To: '),
                            Expanded(
                                child: InkWell(
                              onTap: () async {
                                await _selectToDate(context);
                              },
                              child:
                                  Text(DateFormat('dd-MM-yyyy').format(toDate)),
                            ))
                          ])),
                      TextButton(
                          onPressed: () async {
                            var result = DebthService().getReportDebt(
                                ParamPudget(
                                    userId: 0,
                                    fromDate: fromDate,
                                    toDate: toDate));
                            setState(() {
                              reportDebtData = result;
                            });
                          },
                          child: Text('Search'))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(50),
                  height: 100,
                  child: AspectRatio(
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
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        ReportDebtData debtData = snapshot.data![index];
                        List<DetailReportDebtData> detailData = dataDetail
                            .where((element) => element.index == index)
                            .toList();
                        return Column(
                          children: [
                            ExpansionTile(                             
                              title: Text(
                                  debtData.name +
                                      " | " +
                                      debtData.number.toString(),
                                  style: TextStyle(
                                      color: colors[index],
                                      fontFamily: 'RobotoVietnamese')),
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: detailData.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: Icon(
                                            Icons.account_balance_wallet_outlined),
                                        title: Text(
                                          detailData[index].name,
                                          style: TextStyle(
                                              
                                              fontFamily: 'RobotoVietnamese'),
                                        ),
                                        trailing: Text(
                                          detailData[index].amount.toString(),
                                          style: TextStyle(
                                              color: colors[index]),
                                        ),
                                      );
                                    })
                              ],
                            ),
                          ],
                        );
                      }),
                ),
              ],
            );
          } else {
            return Text("No data.");
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
        color: colors[index],
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

  ListDateTime getFullDays(DateTime dateTime) {
    //Month
    DateTime startOfMonth = DateTime(dateTime.year, dateTime.month, 1);
    DateTime endOfMonth = DateTime(dateTime.year, dateTime.month + 1, 0);

    ListDateTime listDateTime = ListDateTime(
        startOfWeek: DateTime.now(),
        endOfWeek: DateTime.now(),
        startOfMonth: startOfMonth,
        endOfMonth: endOfMonth,
        firstDayOfQuarter: DateTime.now(),
        lastDayOfQuarter: DateTime.now(),
        startOfYear: DateTime.now(),
        endOfYear: DateTime.now());
    return listDateTime;
  }
}

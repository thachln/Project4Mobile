import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../../models/Transaction/TransactionView.dart';

class ListOverviewMonth extends StatelessWidget {
  const ListOverviewMonth(
      {super.key,
      required this.listTransactionTop5,
      required this.listTransactionReport});
  final List<TransactionView> listTransactionTop5;
  final List<TransactionReport> listTransactionReport;

  @override
  Widget build(BuildContext context) {
    if (listTransactionReport.length == 0) {
      return Center(
        child: Text('Không có dữ liệu'),
      );
    }
    if (listTransactionTop5.length == 0) {
      return Center(
        child: Text('Không có dữ liệu'),
      );
    }
    
    final groupedTransactions = <String, double>{};

  for (var transaction in listTransactionReport) {
    String monthYear = DateFormat('MM-yyyy').format(transaction.transactionDate);
    groupedTransactions.update(monthYear, (value) => value + transaction.amount, ifAbsent: () => transaction.amount);
  }
  double maxAmount = groupedTransactions.values.reduce(math.max);
  List<String> month = groupedTransactions.keys.toList();
  List<double> monthValue = groupedTransactions.values.toList();
  
    return Column(
      children: [
        SizedBox(height: 10.0),
        Container(
          height: 200,
          child: BarChart(BarChartData(
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    String monthYear = month[value.toInt()];
                    return SideTitleWidget(
                      child: Text(monthYear),
                      axisSide: meta.axisSide,
                    );
                  },
                ),
              ),
            ),

            gridData: FlGridData(
              show: false,
            ),
            minY: 0, // Điều chỉnh giới hạn dưới nếu cần
            maxY: maxAmount + 10000,
            barGroups: List.generate(monthValue.length, (index) {
              double amount = monthValue[index];
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: amount,
                    color: Colors.blueAccent,
                  ),
                ],
              );
            }),
          )),
        ),
        SizedBox(height: 10.0),
        Text('Chi tiêu nhiều nhất',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ListView.builder(
            itemCount: listTransactionTop5.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              TransactionView transaction = listTransactionTop5[index];
              return ListTile(
                leading: Image.asset("assets/icon/${transaction.cateIcon}"),
                title: Text(transaction.categoryName),
                trailing: Text(transaction.amount.toString()),
                contentPadding: EdgeInsets.only(top: 10),
              );
            })
      ],
    );
  }
  
}


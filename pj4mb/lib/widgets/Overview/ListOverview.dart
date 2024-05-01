import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Transaction/Transaction.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';

class ListWithTime extends StatelessWidget {
  const ListWithTime({super.key, required this.listTransactionTop5, required this.listTransactionWithTime});
  final List<TransactionView> listTransactionTop5;
  final List<TransactionView> listTransactionWithTime;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.0),
        Text('100,000,000đ',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 24.0),
        Container(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: List.generate(7, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: index * 5, // Giả sử số liệu mỗi ngày tăng dần giả định
                  color: Colors.blueAccent,
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(color: Colors.black, fontSize: 14);
                  Widget text;
                  switch (value.toInt()) {
                    case 0:
                      text = const Text('Mon', style: style);
                      break;
                    case 1:
                      text = const Text('Tue', style: style);
                      break;
                    case 2:
                      text = const Text('Wed', style: style);
                      break;
                    case 3:
                      text = const Text('Thu', style: style);
                      break;
                    case 4:
                      text = const Text('Fri', style: style);
                      break;
                    case 5:
                      text = const Text('Sat', style: style);
                      break;
                    case 6:
                      text = const Text('Sun', style: style);
                      break;
                    default:
                      text = const Text('');
                  }
                  return Padding(padding: const EdgeInsets.only(top: 10), child: text);
                },
                reservedSize: 40,
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY: 30,
        ),
      ),
    ),
        SizedBox(height: 8.0),
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
              );
            })
      ],
    );
  }
}

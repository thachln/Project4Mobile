import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pj4mb/models/Transaction/Transaction.dart';
import 'package:pj4mb/models/Transaction/TransactionView.dart';

class ListWithTime extends StatelessWidget {
  const ListWithTime(
      {super.key,
      required this.listTransactionTop5,
      required this.listTransactionReport});
  final List<TransactionView> listTransactionTop5;
  final List<TransactionReport> listTransactionReport;

  @override
  Widget build(BuildContext context) {
    if(listTransactionReport.length == 0){
      return Center(
        child: Text('Không có dữ liệu'),
      );
    }
    if(listTransactionTop5.length == 0){
      return Center(
        child: Text('Không có dữ liệu'),
      );
    }
    var maxAmount = listTransactionReport.map((transaction) => transaction.amount).reduce((value, element) => value > element ? value : element);
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
                    TransactionReport transactionReport =
                        listTransactionReport[value.toInt()];
                    final String date = DateFormat('dd/MM')
                        .format(transactionReport.transactionDate);
                    return SideTitleWidget(
                      child: Text(date),
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
            maxY: maxAmount,
            barGroups: List.generate(listTransactionReport.length, (index) {
              final dayData = listTransactionReport[index];            
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: dayData.amount.toDouble(),
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

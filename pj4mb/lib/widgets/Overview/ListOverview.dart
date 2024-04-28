import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListWithTime extends StatelessWidget {
  const ListWithTime({super.key});

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
                
                ),
          ),
        ),
        SizedBox(height: 8.0),
        Text('Chi tiêu nhiều nhất',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ListView.builder(
            itemCount: 1,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Text('Avatar'),
                title: Text('1'),
                subtitle: Text('ID:'),
                trailing: Text('100%'),
              );
            })
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HistoryWidgets extends StatelessWidget {
  const HistoryWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(('Tiền vào')),
            Expanded(
                child: Text(
              '20000',
              textAlign: TextAlign.right,
            ))
          ],
        ),
        Row(
          children: [
            Text(('Tiền ra')),
            Expanded(
                child: Text(
              '200001',
              textAlign: TextAlign.right,
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
                child: Text(
              '200002',
              textAlign: TextAlign.right,
            ))
          ],
        ),
        ElevatedButton(
            onPressed: () {},
            child: Text(
              'Xem báo cáo giai đoạn này',
              style: TextStyle(color: Colors.green[600]),
            ),style: ElevatedButton.styleFrom(
              foregroundColor: Colors.green[600], backgroundColor: Colors.green[100],
            ),
        ),
        SizedBox(height: 16,),
        Expanded(
          child: Container(
            child: ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Text('567'),
                          title: Text('1'),
                          subtitle: Text('ID:'),
                          trailing: Text('9999'),
                        );
                      })
          ),
        ),
        
      ],
    );
  }
}

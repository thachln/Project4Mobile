import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListGroup extends StatelessWidget {
  const ListGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: GestureDetector(
            onTap: () {
              print('2');
            },
            child: Container(
              color: Colors.green[100],
              child: Row(
                children: [SizedBox(width: 20),Icon(Icons.add),SizedBox(width: 20), Text('Nhóm mới')],
              ),
            ),
          ),
        ),
        SizedBox(height: 6),
        ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    print('1');
                  },
                  child: Container(
                    color: Colors.green[100],
                    child: ListTile(
                      leading: Text('Avatar'),
                      title: Text('Item $index'),
                      subtitle: Text('sub'),
                      trailing: Icon(Icons.arrow_forward_ios_outlined),
                    ),
                  ),
                ),
                SizedBox(height: 6)
              ],
            );
          },
        ),
      ],
    );
  }
}

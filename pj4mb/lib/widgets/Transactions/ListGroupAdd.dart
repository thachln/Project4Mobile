import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListGroupAdd extends StatelessWidget {
  const ListGroupAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 20,
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
                  ),
                ),
              ),
              SizedBox(height: 6)
            ],
          );
        },
      );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/screens/Account/AddCategory.dart';

class ListCategory extends StatelessWidget {
  const ListCategory({super.key, required this.listCategory, required this.onSave, required this.categoryType});
  final List<Category> listCategory;
  final String categoryType;
   final void Function(dynamic value) onSave;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: GestureDetector(
            onTap: () {             
               Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddCategoryPage(categoryType: categoryType,)));
            },
            child: Container(
              color: Colors.green[100],
              child: Row(
                children: [SizedBox(width: 30),Icon(Icons.add),SizedBox(width: 30), Text('Nhóm mới',style: TextStyle(fontSize: 20))],
              ),
            ),
          ),
        ),
        SizedBox(height: 6),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: listCategory.length,
          itemBuilder: (context, index) {
            Category cate = listCategory[index];
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    print('1');
                  },
                  child: Container(
                    color: Colors.green[100],
                    child: ListTile(
                      leading: Image.asset("assets/icon/${cate.icon.path}"),
                      title: Text(cate.name),
                      trailing: Icon(Icons.arrow_forward_ios_outlined),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

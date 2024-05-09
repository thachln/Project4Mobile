import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Category/CateTypeENum.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/screens/Account/AddCategory.dart';

class ListCategoryBudget extends StatelessWidget {
  const ListCategoryBudget(
      {super.key,
      required this.listCategory,
      required this.categoryType,
      required this.onSave});
  final List<Category> listCategory;
  final CateTypeENum categoryType;
  final void Function(dynamic value) onSave;
  @override
  Widget build(BuildContext context) {
    if (categoryType == CateTypeENum.DEBT) {
      return ListView(
        children: [
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
                    onTap: () async {
                      Navigator.pop(
                          context,
                          new Category(
                              categoryID: cate.categoryID,
                              name: cate.name,
                              icon: cate.icon,
                              CategoryType: CateTypeENum.DEBT,
                              user: 0));
                    },
                    child: Container(
                        color: Colors.green[100],
                        child: ListTile(
                          leading: Image.asset("assets/icon/${cate.icon.path}"),
                          title: Text(cate.name),
                        )),
                  ),
                ],
              );
            },
          ),
        ],
      );
    } else {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: GestureDetector(
              onTap: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddCategoryPage(
                              categoryType: categoryType,
                            )));
                if (result) {
                  onSave(result);
                }
              },
              child: Container(
                color: Colors.green[100],
                child: Row(
                  children: [
                    SizedBox(width: 30),
                    Icon(Icons.add),
                    SizedBox(width: 30),
                    Text('Nhóm mới', style: TextStyle(fontSize: 20))
                  ],
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
                    onTap: () async {
                      Navigator.pop(
                          context,
                          new Category(
                              categoryID: cate.categoryID,
                              name: cate.name,
                              icon: cate.icon,
                              CategoryType: CateTypeENum.EXPENSE,
                              user: 0));
                    },
                    child: Container(
                        color: Colors.green[100],
                        child: ListTile(
                          leading: Image.asset("assets/icon/${cate.icon.path}"),
                          title: Text(cate.name),
                        )),
                  ),
                ],
              );
            },
          ),
        ],
      );
    }
  }
}

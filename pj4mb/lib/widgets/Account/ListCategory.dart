import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Category/CateTypeENum.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/screens/Account/AddCategory.dart';
import 'package:pj4mb/screens/Account/UpdateCategory.dart';
import 'package:pj4mb/services/Category_service.dart';

class ListCategory extends StatelessWidget {
  const ListCategory(
      {super.key,
      required this.listCategory,
      required this.onSave,
      required this.categoryType});
  final List<Category> listCategory;
  final CateTypeENum categoryType;

  final void Function(dynamic value) onSave;
  @override
  Widget build(BuildContext context) {
    print(categoryType);
    if(categoryType == CateTypeENum.DEBT){
      return ListView(
      children: [
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
                    var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateCategoryPage(
                                categoryType: categoryType.name,
                                categoryName: cate.name,
                                categoryIcon: "assets/icon/" + cate.icon.path,
                                categoryID: cate.categoryID)));
                    if (result) {
                      onSave(result);
                    }
                  },
                  child: Container(
                    color: Colors.green[100],
                    child: ListTile(
                        leading: Image.asset("assets/icon/${cate.icon.path}"),
                        title: Text(cate.name),
                        trailing: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm?'),
                                  content: Text(
                                      'Are you sure to delete this category, everything in this category will be deleted!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        var result = await CategoryService()
                                            .DeleteCategory(cate.categoryID);
                                        if (result) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Information'),
                                                content:
                                                    Text('Delete success!'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, true);
                                                      Navigator.pop(
                                                          context, true);
                                                      onSave(result);
                                                    },
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Information'),
                                                content: Text('Delete fail!'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, true);
                                                      Navigator.pop(
                                                          context, true);
                                                    },
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Text('OK'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancle'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Icon(Icons.delete_forever_outlined,
                              color: Colors.red, size: 30),
                        )),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
    }
    else{
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
                    var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateCategoryPage(
                                categoryType: categoryType.name,
                                categoryName: cate.name,
                                categoryIcon: "assets/icon/" + cate.icon.path,
                                categoryID: cate.categoryID)));
                    if (result) {
                      onSave(result);
                    }
                  },
                  child: Container(
                    color: Colors.green[100],
                    child: ListTile(
                        leading: Image.asset("assets/icon/${cate.icon.path}"),
                        title: Text(cate.name),
                        trailing: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm?'),
                                  content: Text(
                                      'Are you sure to delete this category, everything in this category will be deleted!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        var result = await CategoryService()
                                            .DeleteCategory(cate.categoryID);
                                        if (result) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Information'),
                                                content:
                                                    Text('Delete success!'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, true);
                                                      Navigator.pop(
                                                          context, true);
                                                      onSave(result);
                                                    },
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Information'),
                                                content: Text('Delete fail!'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, true);
                                                      Navigator.pop(
                                                          context, true);
                                                    },
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Text('OK'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancle'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Icon(Icons.delete_forever_outlined,
                              color: Colors.red, size: 30),
                        )),
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
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Category/Cat_Icon.dart';
import 'package:pj4mb/models/Category/CateTypeENum.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/screens/Account/Category.dart';
import 'package:pj4mb/services/Category_service.dart';

class UpdateCategoryPage extends StatefulWidget {
  const UpdateCategoryPage({super.key, required this.categoryType, required this.categoryName, required this.categoryIcon, required this.categoryID});
  final String categoryType;
  final String categoryName;
  final String categoryIcon;
  final int categoryID;
  @override
  State<UpdateCategoryPage> createState() => _UpdateCategoryPageState();
}

class _UpdateCategoryPageState extends State<UpdateCategoryPage> {
  late TextEditingController categoryName;
  late TextEditingController categoryIcon;
  late TextEditingController categoryTypeValue;
  List<String> icons = [
    'assets/icon/anotherbill.png',
    'assets/icon/beauty.png',
    'assets/icon/bill&fees.png',
    'assets/icon/business.png',
    'assets/icon/drink.png',
    'assets/icon/education.png',
    'assets/icon/entertainment.png',
    'assets/icon/extraincome.png',
    'assets/icon/food.png',
    'assets/icon/gift.png',
    'assets/icon/grocery.png',
    'assets/icon/home.png',
    'assets/icon/homebill.png',
    'assets/icon/loan.png',
    'assets/icon/other.png',
    'assets/icon/phonebill.png',
    'assets/icon/salary.png',
    'assets/icon/shopping.png',
    'assets/icon/transport.png',
    'assets/icon/travel.png',
    'assets/icon/waterbill.png'
  ];

  @override
  void initState() {
    super.initState();
    categoryName = TextEditingController();
    categoryIcon = TextEditingController();
    categoryTypeValue = TextEditingController(text: widget.categoryType);
  }

  @override
  Widget build(BuildContext context) {
    categoryName.text = widget.categoryName;
    categoryTypeValue.text = widget.categoryType;
    categoryIcon.text = widget.categoryIcon;
    return Scaffold(
      //backgroundColor: Colors.black87,
      appBar: AppBar(
          title: Text(
        "Edit category",
      )),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        //color :Colors.grey[500],
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.question_mark_outlined),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: categoryName,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(hintText: 'Category Name'),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Icon(Icons.exposure),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: categoryTypeValue,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Icon(Icons.insert_emoticon_outlined),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Chọn icon'),
                          content: Container(
                            width: double.maxFinite,
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: icons.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                              ),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      categoryIcon.text = icons[index];
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Image.asset(icons[index]),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: categoryIcon.text.isEmpty
                      ? Text('Chosse icon')
                      : Image.asset(
                          categoryIcon.text, // Hiển thị icon đã chọn
                          width: 50,
                          height: 50,
                          alignment: Alignment.centerLeft,
                        ),
                ))
              ],
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: () async {
                if(categoryName.text.isEmpty || categoryIcon.text.isEmpty){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Arlet'),
                        content: Text('Please fill name and choose icon!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }
                var typeCategory = widget.categoryType == CateTypeENum.INCOME
                    ? CateTypeENum.INCOME
                    : widget.categoryType == CateTypeENum.EXPENSE
                        ? CateTypeENum.EXPENSE
                        : CateTypeENum.DEBT;
                var listIcons = await CategoryService().GetIcon();
                var element = listIcons.firstWhere((element) => element.path == categoryIcon.text.replaceAll('assets/icon/',''));

                Category category = new Category(
                    categoryID: widget.categoryID,
                    name: categoryName.text.toString(),
                    CategoryType: typeCategory,
                    icon: element,
                    user: 0);            
                var result = await CategoryService().updateCategory(category);
                if (result) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Arlet'),
                        content: Text('Update success!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                              Navigator.pop(context, true);
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
                        title: Text('Arlet'),
                        content: Text('Error: Update fail!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Update'),
            )
          ],
        ),
      ),
    );
  }
}

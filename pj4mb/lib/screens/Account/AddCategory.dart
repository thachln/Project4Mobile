import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Category/Cat_Icon.dart';
import 'package:pj4mb/models/Category/CateTypeENum.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/screens/Account/Category.dart';
import 'package:pj4mb/services/Category_service.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key, required this.categoryType});
  final CateTypeENum categoryType;
  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
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
    categoryTypeValue = TextEditingController(text: widget.categoryType.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black87,
      appBar: AppBar(
          title: Text(
        "Add new category",
      )),
      body: Container(
        margin: EdgeInsets.all(10),
        //color :Colors.grey[500],
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.abc),
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
                Icon(Icons.type_specimen),
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
                      ? Text('Chọn icon')
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
                var typeCategory = widget.categoryType == 'Income'
                    ? CateTypeENum.INCOME
                    : widget.categoryType == 'Expense'
                        ? CateTypeENum.EXPENSE
                        : CateTypeENum.DEBT;
                var listIcons = await CategoryService().GetIcon();
                var element = listIcons.firstWhere((element) => element.path == categoryIcon.text.replaceAll('assets/icon/',''));
                print(element.toJson());
                Category category = new Category(
                    categoryID: 0,
                    name: categoryName.text.toString(),
                    CategoryType: typeCategory,
                    icon: element,
                    user: 0);            
                var result = await CategoryService().InsertCategory(category);
                if (result) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Thông báo'),
                        content: Text('Insert success!'),
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
                        title: Text('Thông báo'),
                        content: Text('Error: Insert fail!'),
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
              child: Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}

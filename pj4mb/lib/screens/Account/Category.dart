import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Category/CateTypeENum.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/services/Category_service.dart';
import 'package:pj4mb/widgets/Account/ListCategory.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late Future<List<Category>> cateList;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    cateList = CategoryService().GetCategory('1');
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Group')),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Khoản chi'),
                  Tab(text: 'Khoản thu'),
                  Tab(text: 'Vay/Nợ'),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    FutureBuilder<List<Category>>(
                      future: cateList,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Category>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return ListCategory(
                            onSave: (value) {
                              print('Saved: $value');
                            },
                            listCategory: snapshot.data!.where((element) => element.CategoryType == CateTypeENum.EXPENSE).toList(),categoryType: 'Expense',
                          );
                        }
                      },
                    ),
                    FutureBuilder<List<Category>>(
                      future: cateList,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Category>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return ListCategory(
                            onSave: (value) {
                              print('Saved: $value');
                            },
                            listCategory: snapshot.data!.where((element) => element.CategoryType == CateTypeENum.INCOME).toList(),categoryType: 'Income',
                          );
                        }
                      },
                    ),
                    FutureBuilder<List<Category>>(
                      future: cateList,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Category>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return ListCategory(
                            onSave: (value) {                            
                              print('Saved: $value');
                            },
                            listCategory: snapshot.data!.where((element) => element.CategoryType == CateTypeENum.DEBT).toList(), categoryType: 'Debt',
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

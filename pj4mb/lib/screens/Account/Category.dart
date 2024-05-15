import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj4mb/models/Category/CateTypeENum.dart';
import 'package:pj4mb/models/Category/Category.dart';
import 'package:pj4mb/services/Category_service.dart';
import 'package:pj4mb/widgets/Account/ListCategory.dart';
import 'package:pj4mb/widgets/Budget/ListCategoryBudget.dart';
import 'package:pj4mb/widgets/SavingGoal/ListCategorySaving.dart';
import 'package:pj4mb/widgets/Transactions/ListCategoryTransaction.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key, required this.Type}) : super(key: key);
  final String Type;
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
    if(widget.Type == "InEx" || widget.Type == "Goal" || widget.Type == "InExChoose")
    {
      _tabController = TabController(length: 2, vsync: this);
    }
    else if(widget.Type == "In" || widget.Type == "Ex" || widget.Type == "Debt"){
      _tabController = TabController(length: 1, vsync: this);
    }
    
    
    cateList = CategoryService().GetCategory();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.Type == "InEx" || widget.Type == "InExChoose")
    {
      // #region nomal
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
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.78,
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
                          if(widget.Type == "InEx")
                          {
                             return ListCategory(
                            onSave: (value) {
                              setState(() {
                                cateList = CategoryService().GetCategory();
                              });
                            },
                            listCategory: snapshot.data!.where((element) => element.CategoryType == CateTypeENum.EXPENSE).toList(),categoryType: CateTypeENum.EXPENSE,
                          );
                          }
                          else{
                             return ListCategoryTransaction(
                            onSave: (value) {
                              setState(() {
                                cateList = CategoryService().GetCategory();
                              });
                            },
                            listCategory: snapshot.data!.where((element) => element.CategoryType == CateTypeENum.EXPENSE).toList(),categoryType:  CateTypeENum.EXPENSE,
                          );
                          }
                         
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
                          if(widget.Type == "InEx")
                          {
                             return ListCategory(
                            onSave: (value) {
                              setState(() {
                                cateList = CategoryService().GetCategory();
                              });
                            },
                            listCategory: snapshot.data!.where((element) => element.CategoryType == CateTypeENum.INCOME).toList(),categoryType:  CateTypeENum.INCOME,
                          );
                          }
                          else{
                             return ListCategoryTransaction(
                            onSave: (value) {
                              setState(() {
                                cateList = CategoryService().GetCategory();
                              });
                            },
                            listCategory: snapshot.data!.where((element) => element.CategoryType == CateTypeENum.INCOME).toList(),categoryType:  CateTypeENum.INCOME,
                          );
                          }
                          
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
    // #endregion
    }
    else if (widget.Type == "Ex"){
      // #region add budget
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
                          return ListCategoryBudget(
                            onSave: (value) {
                              setState(() {
                                cateList = CategoryService().GetCategory();
                              });
                            },
                            listCategory: snapshot.data!.where((element) => element.CategoryType == CateTypeENum.EXPENSE).toList(),categoryType:  CateTypeENum.EXPENSE,
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
      // #endregion
    }
    else if (widget.Type == "In"){
      // #region add budget
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
                  Tab(text: 'Khoản thu'),
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
                          return ListCategoryBudget(
                            onSave: (value) {
                              setState(() {
                                cateList = CategoryService().GetCategory();
                              });
                            },
                            listCategory: snapshot.data!.where((element) => element.CategoryType == CateTypeENum.INCOME).toList(),categoryType:  CateTypeENum.INCOME,
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
    else if (widget.Type == "Debt")
    {
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
                          return ListCategoryBudget(
                            onSave: (value) {                            
                               setState(() {
                                cateList = CategoryService().GetCategory();
                              });
                            },
                            listCategory: snapshot.data!.where((element) => element.CategoryType == CateTypeENum.DEBT).toList(), categoryType:  CateTypeENum.DEBT,
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
    else{
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
                          return ListCategorySaving(
                            onSave: (value) {                            
                               setState(() {
                                cateList = CategoryService().GetCategory();
                              });
                            },
                            listCategory: snapshot.data!.where((element) => element.name == "Outgoing Transfer").toList(), categoryType:  CateTypeENum.EXPENSE,
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
                          return ListCategorySaving(
                            onSave: (value) {                            
                               setState(() {
                                cateList = CategoryService().GetCategory();
                              });
                            },
                            listCategory: snapshot.data!.where((element) => element.name == "Incoming Transfer").toList(), categoryType:  CateTypeENum.INCOME,
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
}

import 'package:pj4mb/models/Category/Cat_Icon.dart';
import 'package:pj4mb/models/Category/CateTypeENum.dart';
import 'package:pj4mb/models/User/User.dart';

class Category{
  late final int categoryID;
  late final String name;
  late final CateTypeENum CategoryType;
  late final Cat_Icon icon;
  late int user;
  

  Category({required this.categoryID,required this.name,required this.CategoryType,required this.icon,required this.user});


  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryID: json['id'],
      name: json['name'],
      CategoryType: CateTypeENum.values.firstWhere((e) => e.toString() == 'CateTypeENum.'+json['type']),
      icon: Cat_Icon.fromJson(json['icon']),
      user: json['userId'],
    );
  }


  Map<String, dynamic> toJson() => {
    'id': categoryID,
    'name': name,
    'type': CategoryType.toString().split('.').last,
    'icon': icon.toJson(),
    'userId': user,
  };
}

class CategoryResponse{
  late final int categoryID;
  late final String name;
  late final CateTypeENum CategoryType;
  late final String icon;
  late int user;
  

  CategoryResponse({required this.categoryID,required this.name,required this.CategoryType,required this.icon,required this.user});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      categoryID: json['id'],
      name: json['name'],
      CategoryType: CateTypeENum.values.firstWhere((e) => e.toString() == 'CateTypeENum.'+json['type']),
      icon: json['icon'],
      user: json['userId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': categoryID,
    'name': name,
    'type': CategoryType.toString().split('.').last,
    'icon': icon,
    'userId': user,
  };
}
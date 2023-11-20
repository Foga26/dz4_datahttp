import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

Future<List<Category>> fetchData() async {
  // Проверка подключения к Интернету
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.none) {
    return getLocalData();
  } else {
    var url = 'https://www.themealdb.com/api/json/v1/1/categories.php';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var categoriesData = data['categories'] as List;
      List<Category> categories = categoriesData
          .map((category) => Category.fromJson(category))
          .toList();
      Hive.box<Category>('categories').addAll(categories);
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

List<Category> getLocalData() {
  return Hive.box<Category>('categories').values.toList();
}

class Category {
  final int idCategory;
  final String strCategory;
  final String strCategoryThumb;
  final String strCategoryDescription;

  Category(
      {required this.idCategory,
      required this.strCategory,
      required this.strCategoryThumb,
      required this.strCategoryDescription});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      idCategory: int.parse(json['idCategory']),
      strCategory: json['strCategory'],
      strCategoryThumb: json['strCategoryThumb'],
      strCategoryDescription: json['strCategoryDescription'],
    );
  }
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final typeId = 0;

  @override
  Category read(BinaryReader reader) {
    var idCategory = reader.readInt();
    var strCategory = reader.readString();
    var strCategoryThumb = reader.readString();
    var strCategoryDescription = reader.readString();

    return Category(
      idCategory: idCategory,
      strCategory: strCategory,
      strCategoryThumb: strCategoryThumb,
      strCategoryDescription: strCategoryDescription,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer.writeInt(obj.idCategory);
    writer.writeString(obj.strCategory);
    writer.writeString(obj.strCategoryThumb);
    writer.writeString(obj.strCategoryDescription);
  }
}

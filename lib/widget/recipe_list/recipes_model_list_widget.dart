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
    // var url = 'https://www.themealdb.com/api/json/v1/1/categories.php';
    // var response = await http.get(Uri.parse(url));
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/search.php?s=chicken'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      var categoriesData = data['meals'] as List;

      // data['categories'] as List;
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
  final int idMeal;
  final String strMeal;
  final String strMealThumb;
  final String strArea;

  Category(
      {required this.idMeal,
      required this.strMeal,
      required this.strMealThumb,
      required this.strArea});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      idMeal: int.parse(json['idMeal']),
      strMeal: json['strMeal'],
      strMealThumb: json['strMealThumb'],
      strArea: json['strArea'],
    );
  }
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final typeId = 0;

  @override
  Category read(BinaryReader reader) {
    var idMeal = reader.readInt();
    var strMeal = reader.readString();
    var strMealThumb = reader.readString();
    var strArea = reader.readString();

    return Category(
      idMeal: idMeal,
      strMeal: strMeal,
      strMealThumb: strMealThumb,
      strArea: strArea,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer.writeInt(obj.idMeal);
    writer.writeString(obj.strMeal);
    writer.writeString(obj.strMealThumb);
    writer.writeString(obj.strArea);
  }
}

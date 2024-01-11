// import 'dart:convert';

// import 'package:dz_2/resources/remote_ingredient.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class Repository extends ChangeNotifier {
//   var testList = <RecipeIngridient>[];
//   Future<List<RecipeIngridient>> getRecipeIngredient() async {
//     String apiUrl = 'https://foodapi.dzolotov.tech/recipe_ingredient';

//     final response = await http.get(Uri.parse(apiUrl));
//     final Map<String, dynamic> data = jsonDecode(response.body);
//     final dataList = data.entries
//         .map((e) => RecipeIngridient.fromJson(e.value as Map<String, dynamic>))
//         .toList();
//     testList.addAll(dataList);
//     return testList;
//   }
// }

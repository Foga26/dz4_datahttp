import 'dart:convert';

import 'package:dz_2/resources/main_navigation.dart';
import 'package:dz_2/resources/remote_ingredient.dart';
import 'package:dz_2/widget/recipe_info_widget/recipe_ingredient.dart';
import 'package:dz_2/widget/recipe_list/recipes_model_list_widget.dart';
import 'package:flutter/material.dart';

class RecipesListModel extends ChangeNotifier {
  var recipeInfoList = <RecipeInfoList>[];

  Future<void> loadRecipeList() async {
    final moviesResponce = await fetchData();
    recipeInfoList.addAll(moviesResponce);
    notifyListeners();
  }

  void onMovieTap(BuildContext context, int index) {
    final id = recipeInfoList[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.recipeInfoPage, arguments: id);
  }
}

// class RecipeIngridientModel extends ChangeNotifier {
//   List<RecipeIngredientr> recipeIngredients = [];

//   Future<void> loadRecipeIngridient() async {
//     final responserecipeIngridient = await fetchRecipeIngredients();
//     recipeIngredients.addAll(responserecipeIngridient);

//     notifyListeners();
//   }
// }

class MeasureUnitModel extends ChangeNotifier {
  var measureUnitList = <MeasureUnit>[];

  Future<void> loadRecipeList() async {
    final measureResponce = await fetchMeasureUnit();
    measureUnitList.addAll(measureResponce);
    notifyListeners();
  }

  // void onMovieTap(BuildContext context, int index) {
  //   final id = measureUnitList[index].id;
  //   Navigator.of(context)
  //       .pushNamed(MainNavigationRouteNames.recipeInfoPage, arguments: id);
  // }
}

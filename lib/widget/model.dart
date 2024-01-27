import 'package:dz_2/resources/local_data.dart';
import 'package:dz_2/resources/remote_ingredient.dart';

import 'package:dz_2/widget/recipe_info_widget/recipe_step_link.dart';
import 'package:dz_2/widget/recipe_list/recipes_model_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RecipesListModel extends ChangeNotifier {
  var recipeInfoList = <RecipeInfoList>[];
  var favorites = <RecipeInfoListLocal>[];
  bool isvaF = false;
  final Box<RecipeInfoListLocal> _favoritesBox =
      Hive.box<RecipeInfoListLocal>('favoritesRecipe');
  List<RecipeInfoListLocal> get favoritesBox => _favoritesBox.values.toList();

  void addToFavorites(RecipeInfoListLocal recipe) {
    _favoritesBox.put(recipe.id, recipe);

    notifyListeners();
  }

  bool isFavorite(RecipeInfoListLocal recipe) {
    return _favoritesBox.containsKey(recipe.id);
  }

  void removeFromFavorites(RecipeInfoListLocal recipe) {
    _favoritesBox.delete(recipe.id);

    notifyListeners();
  }

  Future<void> loadRecipeList() async {
    final recipeListResponse = await fetchData();
    recipeInfoList.addAll(recipeListResponse);

    notifyListeners();
  }
}

class RecipesIngredientListModel extends ChangeNotifier {
  var recipeInfoList = <RecipeIngridient>[];
  var igredientListModel = <Ingredient>[];

  Future<void> loadRecipeList(id) async {
    final recipeListResponse = await fetchRecipeIngredients(id);
    final ingredientResponse = await fetchIngredients();
    recipeInfoList.addAll(recipeListResponse);
    igredientListModel.addAll(ingredientResponse);
    notifyListeners();
  }
}

class RecipeStepModel extends ChangeNotifier {
  var recipeStepLink = <RecipeStepLink>[];

  Future<void> loadRecipeStepLink(id) async {
    final recipeStepResponse = await fetchRecipeStepLinks(id);
    recipeStepLink.addAll(recipeStepResponse);
    notifyListeners();
  }
}

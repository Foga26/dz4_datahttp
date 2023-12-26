import 'package:dz_2/resources/main_navigation.dart';
import 'package:dz_2/resources/remote_ingredient.dart';
import 'package:dz_2/widget/recipe_list/recipes_model_list_widget.dart';
import 'package:flutter/material.dart';

class MovieListModel extends ChangeNotifier {
  var movies = <RecipeInfoList>[];

  Future<void> loadRecipeList() async {
    final moviesResponce = await fetchData();
    movies.addAll(moviesResponce);
    notifyListeners();
  }

  void onMovieTap(BuildContext context, int index) {
    final id = movies[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.recipeInfoPage, arguments: id);
  }
}

import 'dart:io';

import 'package:dz_2/resources/remote_ingredient.dart';
import 'package:dz_2/widget/recipe_list/recipes_model_list_widget.dart';
import 'package:flutter/material.dart';

class MovieListModel with ChangeNotifier {
  final _apiClient = HttpClient();
  final _movies = <RecipeInfoList>[];
  List<RecipeInfoList> get movies => List.unmodifiable(_movies);
  Future<void> loadRecipeList() async {
    final moviesResponce = await fetchData();
    _movies.addAll(moviesResponce);
    notifyListeners();
  }
}

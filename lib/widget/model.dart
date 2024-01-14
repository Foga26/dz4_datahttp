import 'package:dz_2/resources/remote_ingredient.dart';
import 'package:dz_2/widget/recipe_list/recipes_model_list_widget.dart';
import 'package:flutter/material.dart';

class RecipesListModel extends ChangeNotifier {
  var recipeInfoList = <RecipeInfoList>[];

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

// class IngredientListModel extends ChangeNotifier {
//   var igredientListModel = <Ingredient>[];

//   Future<void> loadRecipeList() async {
//     final recipeListResponse = await fetchIngredients();
//     igredientListModel.addAll(recipeListResponse);
//     notifyListeners();
//   }
// }











// class IngredientModel {
//   Future<void> fetchDataAndSaveToHive() async {
//     // Проверяем подключение к интернету
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       // Используем данные из базы данных Hive в случае отсутствия интернета
//       return;
//     }

//     // Подключаемся к Hive
//     await Hive.initFlutter();
//     await Hive.openBox<Ingredient>('ingredients');

//     try {
//       // Загружаем данные с сайта
//       final response =
//           await http.get(Uri.parse('https://foodapi.dzolotov.tech/ingredient'));
//       if (response.statusCode == 200) {
//         // Преобразуем данные в список объектов Ingredient
//         final List<dynamic> data = jsonDecode(response.body);
//         final List<Ingredient> ingredients = data
//             .map((json) => Ingredient(
//                   id: json['id'],
//                   name: json['name'],
//                   caloriesForUnit: json['caloriesForUnit'],
//                   measureUnit: MeasureUnit(
//                       id: json['measureUnit']['id'],
//                       one: 'one',
//                       few: 'few',
//                       many: 'many'),
//                 ))
//             .toList();

//         // Сохраняем данные в базе данных Hive
//         final box = Hive.box<Ingredient>('ingredients');
//         box.clear();
//         box.addAll(ingredients);
//       } else {
//         // Обработка ошибки при получении данных с сайта
//         throw Exception('Failed to load data');
//       }
//     } catch (error) {
//       // Обработка ошибки
//       print(error);
//     }
//   }
// }







// class RecipeIngridientModel extends ChangeNotifier {
//   var recipeIngridient = <RecipeIngridient>[];

//   Future<void> loadRecipeList() async {
//     final recipeListResponse = await fetchRecipeIngredients(1);
//     recipeIngridient.addAll(recipeListResponse);
//     notifyListeners();
//   }
// }

// class IngredientModel extends ChangeNotifier {
//   var ingridientsList = <Ingredient>[];

//   Future<void> loadRecipeList() async {
//     final recipeListResponse = await fetchIngredients();
//     ingridientsList.addAll(recipeListResponse);
//     notifyListeners();
//   }
// }

// class RecipeStepLinkModel extends ChangeNotifier {
//   var recipeStepLinkList = <RecipeStepLink>[];

//   Future<void> loadRecipeList() async {
//     final recipeListResponse = await fetchRecipeStepLinks(1);
//     recipeStepLinkList.addAll(recipeListResponse);
//     notifyListeners();
//   }
// }

// class RecipeStepkModel extends ChangeNotifier {
//   var recipeStepList = <RecipeStep>[];

//   Future<void> loadRecipeList() async {
//     final recipeListResponse = await fetchRecipeStep();
//     recipeStepList.addAll(recipeListResponse);
//     notifyListeners();
//   }
// }

// class MeasureUnitModel extends ChangeNotifier {
//   var measureUnitList = <MeasureUnit>[];

//   Future<void> loadRecipeList() async {
//     final recipeListResponse = await fetchIngredientsMeasureUnit();
//     measureUnitList.addAll(recipeListResponse);
//     notifyListeners();
//   }
// }

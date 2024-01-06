// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dz_2/resources/remote_ingredient.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RecipeIngredientr {
  final int id;
  final int count;
  final Ingredientr ingredientId;
  final int recipeId;

  RecipeIngredientr({
    required this.id,
    required this.count,
    required this.ingredientId,
    required this.recipeId,
  });
}

// Адаптер для Hive
class RecipeIngredientAdapter extends TypeAdapter<RecipeIngredientr> {
  @override
  final int typeId = 5;

  @override
  RecipeIngredientr read(BinaryReader reader) {
    var id = reader.readInt();
    var count = reader.readInt();
    var ingredientId = reader.read();
    var recipeId = reader.readInt();
    return RecipeIngredientr(
      id: id,
      count: count,
      ingredientId: ingredientId,
      recipeId: recipeId,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeIngredientr obj) {
    writer.writeInt(obj.id);
    writer.writeInt(obj.count);
    writer.write(obj.ingredientId);
    writer.writeInt(obj.recipeId);
  }
}

class Ingredientr {
  final int id;
  final String name;
  final double caloriesForUnit;
  final MeasureUnit measureUnit;

  Ingredientr({
    required this.id,
    required this.name,
    required this.caloriesForUnit,
    required this.measureUnit,
  });
}

// // // Главный виджет Flutter
// class RecipeIngrtttt extends StatefulWidget {
//   @override
//   _RecipeIngrttttState createState() => _RecipeIngrttttState();
// }

// class _RecipeIngrttttState extends State<RecipeIngrtttt> {
//   final String apiUrl = 'https://foodapi.dzolotov.tech/recipe_ingredient';

//   List<RecipeIngredientr> recipeIngredients = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchRecipeIngredients();
//   }

//   Future<void> fetchRecipeIngredients() async {
//     final response = await http.get(Uri.parse(apiUrl));
//     final responseId = await http.get(Uri.parse(apiUrl));

//     if (response.statusCode == 200) {
//       List<dynamic> data = jsonDecode(response.body);

//       recipeIngredients = data
//           // .where((recipeId) => recipeId['recipe']['id'] == 1)
//           .map((e) => RecipeIngredientr(
//                 id: e['id'],
//                 count: e['count'],
//                 ingredientId: e['ingredient']['id'],
//                 recipeId: e['recipe']['id'],
//               ))
//           .toList();

//       // Добавление данных в базу Hive
//       // recipeIngredientBox.clear();
//       // recipeIngredientBox.addAll(recipeIngredients);

//     } else {
//       throw Exception('Failed to fetch recipe ingredients');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var model = NotifierProvider.watch<RecipesListModel>(context);
//     return SizedBox(
//         width: 150,
//         height: 450,
//         child: recipeIngredients.isEmpty
//             ? Center(child: CircularProgressIndicator())
//             : ListView.builder(
//                 physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: recipeIngredients.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final ingredient = recipeIngredients[index];

//                   return Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('Ingredient Count: ${ingredient.count}'),
//                     ],
//                   );
//                 }));
//   }
// }
 // Column ingridientsListss(List<String> strings) {
  //   List<String> wordWidgetsss = [];
  //   for (String string in recipeIngredients) {
  //     List<String> words = string.split(',');

  //     for (String word in words) {
  //       {
  //         wordWidgetsss.add(word);
  //       }
  //     }
  //   }
  //   List<Widget> wordWidgets = wordWidgetsss
  //       .map((word) => Padding(
  //             padding: const EdgeInsets.only(top: 15),
  //             child: Text(
  //               word,
  //               style: const TextStyle(
  //                   height: 2.1,
  //                   color: Colors.grey,
  //                   fontSize: 13,
  //                   fontWeight: FontWeight.w400),
  //             ),
  //           ))
  //       .toList();
  //   return Column(
  //     children: wordWidgets,
  //   );
  // }
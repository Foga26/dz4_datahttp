import 'dart:async';
import 'dart:convert';
import 'package:dz_2/resources/remote_ingredient.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class IngredientBloc {
  final _ingredientsController = StreamController<List<Ingredient>>();
  Stream<List<Ingredient>> get ingredientsStream =>
      _ingredientsController.stream;

  Future<void> getIngredients() async {
    try {
      final response =
          await http.get(Uri.parse('https://foodapi.dzolotov.tech/ingredient'));
      final jsonData = json.decode(response.body) as List<dynamic>;
      final ingredients =
          jsonData.map((json) => Ingredient.fromJson(json)).toList();

      final ingredientsBox = Hive.box('ingredients');
      ingredientsBox.clear();
      ingredientsBox.addAll(ingredients);

      _ingredientsController.sink.add(ingredients);
    } catch (e) {
      _ingredientsController.addError(e.toString());
    }
  }

  void dispose() {
    _ingredientsController.close();
  }
}

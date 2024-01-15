import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dz_2/resources/remote_ingredient.dart';
import 'package:dz_2/widget/recipe_info_widget/recipe_step_link.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class RecipeListInfoAdapter extends TypeAdapter<RecipeInfoList> {
  @override
  final typeId = 6;

  @override
  RecipeInfoList read(BinaryReader reader) {
    var id = reader.readInt();
    var name = reader.readString();
    var photo = reader.readString();
    var duration = reader.readInt();

    return RecipeInfoList(
      id: id,
      name: name,
      photo: photo,
      duration: duration,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeInfoList obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.photo);
    writer.writeInt(obj.duration);
  }
}

class RecipeIngridientListInfoAdapter extends TypeAdapter<RecipeIngridient> {
  @override
  final typeId = 7;

  @override
  RecipeIngridient read(BinaryReader reader) {
    var id = reader.readInt();
    var count = reader.readInt();
    var ingredientId = reader.read() as Ingredient;
    var recipeId = reader.readInt();
    return RecipeIngridient(
      id: id,
      count: count,
      ingredientId: ingredientId,
      recipeId: recipeId,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeIngridient obj) {
    writer.writeInt(obj.id);
    writer.writeInt(obj.count);
    writer.write(obj.ingredientId);
    writer.writeInt(obj.recipeId);
  }
}

class IngridientListInfoAdapter extends TypeAdapter<Ingredient> {
  @override
  final typeId = 8;

  @override
  Ingredient read(BinaryReader reader) {
    var id = reader.readInt();
    var name = reader.readString();
    var caloriesForUnit = reader.readDouble();
    var measureUnit = reader.read() as MeasureUnit;
    return Ingredient(
      id: id,
      name: name,
      caloriesForUnit: caloriesForUnit,
      measureUnit: measureUnit,
    );
  }

  @override
  void write(BinaryWriter writer, Ingredient obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.writeDouble(obj.caloriesForUnit);
    writer.write(obj.measureUnit);
  }
}

class MeasureUnitAdapter extends TypeAdapter<MeasureUnit> {
  @override
  final typeId = 9;

  @override
  MeasureUnit read(BinaryReader reader) {
    var id = reader.readInt();

    return MeasureUnit(
      id: id,
      one: 'one',
      few: 'few',
      many: 'many',
    );
  }

  @override
  void write(BinaryWriter writer, MeasureUnit obj) {
    writer.writeInt(obj.id);
  }
}

Future<List<RecipeInfoList>> fetchData() async {
  // Проверка подключения к Интернету
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.none) {
    return getLocalData();
  } else {
    final response =
        await http.get(Uri.parse('https://foodapi.dzolotov.tech/recipe'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;

      // data['categories'] as List;
      List<RecipeInfoList> recipeInfoList =
          data.map((recipeinf) => RecipeInfoList.fromJson(recipeinf)).toList();
      Hive.box<RecipeInfoList>('recipe').clear();
      Hive.box<RecipeInfoList>('recipe').addAll(recipeInfoList);
      return recipeInfoList;
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

List<RecipeInfoList> getLocalData() {
  return Hive.box<RecipeInfoList>('recipe').values.toList();
}

List<RecipeIngridient> getLocalDataIngr() {
  return  Hive.box<RecipeIngridient>('recipeIngredientInfoDetail')
      .values
      .toList();
}

Future<List<RecipeIngridient>> fetchRecipeIngredients(ricepiIdd) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  final Box<RecipeIngridient> recipeIngredientBox =
      Hive.box<RecipeIngridient>('recipeIngredientInfoDetail');
  if (connectivityResult == ConnectivityResult.none) {
    return getLocalDataIngr();
  } else {
    String apiUrl = 'https://foodapi.dzolotov.tech/recipe_ingredient';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var bbb = <Ingredient>[];
      var ingredient = await fetchIngredients();
      bbb.addAll(ingredient);

      await fetchIngredientsMeasureUnit();

      var data = jsonDecode(response.body) as List;
      // var bb = measureUnit
      //     .firstWhere((element) => element.id == element.measureUnit.id)
      //     .id;
      List<RecipeIngridient> recipeIngredients = data
          .where((recipeId) => recipeId['recipe']['id'] == ricepiIdd)
          .map((e) => RecipeIngridient(
              id: e['id'],
              count: e['count'],
              ingredientId: Ingredient(
                  id: e['ingredient']['id'],
                  name: bbb
                      .firstWhere((ingredient) =>
                          ingredient.id == e['ingredient']['id'])
                      .name,
                  caloriesForUnit: 0,
                  measureUnit:
                      MeasureUnit(id: e['id'], one: '', few: '', many: '')),
              recipeId: e['recipe']['id']))
          .toList();
      recipeIngredientBox.clear();
      recipeIngredientBox.addAll(recipeIngredients);

      // setState(() {});

      // Добавление данных в базу Hive

      return recipeIngredientBox.values.toList();
    } else {
      throw Exception('Failed to fetch recipe ingredients');
    }
  }
}

List<Ingredient> getLocalIngr() {
  return Hive.box<Ingredient>('recipeIngredientInfo').values.toList();
}

Future<List<Ingredient>> fetchIngredients() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  final Box<Ingredient> recipeIngredientBox =
      Hive.box<Ingredient>('recipeIngredientInfo');
  if (connectivityResult == ConnectivityResult.none) {
    return getLocalIngr();
  }
  // fetchRecipeIngredients(
  //   widget.id,
  // );
  // fetchIngredientsMeasureUnit();
  String apiUrl = 'https://foodapi.dzolotov.tech/ingredient';
  final response = await http.get(Uri.parse(apiUrl));
  // await fetchRecipeIngredients(widget.id);

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);

    List<Ingredient> ingredientr = data
        .map((e) => Ingredient(
            id: e['id'],
            name: e['name'],
            caloriesForUnit: 0,
            measureUnit: MeasureUnit(
                id: e['measureUnit']['id'],
                one: 'one',
                few: 'few',
                many: 'many')))
        .toList();

    // // Добавление данных в базу Hive
    recipeIngredientBox.clear();
    recipeIngredientBox.addAll(ingredientr);
    return ingredientr;
  } else {
    throw Exception('Failed to fetch recipe ingredients');
  }
}

List<RecipeStepLink> getLocalDataRecipeStepLink() {
  return Hive.box<RecipeStepLink>('recipeStepLinkInfo').values.toList();
}

List<RecipeStep> getLocalDataRecipeStep() {
  return Hive.box<RecipeStep>('recipeStepInfo').values.toList();
}

Future<List<RecipeStepLink>> fetchRecipeStepLinks(
  ricepiIdd,
) async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.none) {
    return getLocalDataRecipeStepLink();
  } else {
    String apiUrl = 'https://foodapi.dzolotov.tech/recipe_step_link';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      await fetchRecipeStep();
      List<dynamic> data = jsonDecode(response.body);
      // var bb = measureUnit
      //     .firstWhere((element) => element.id == element.measureUnit.id)
      //     .id;
      List<RecipeStepLink> recipeStepLink = data
          .where((recipeId) => recipeId['recipe']['id'] == ricepiIdd)
          .map((e) => RecipeStepLink.fromJson(e))
          .toList();

      // Добавление данных в базу Hive
      Hive.box<RecipeStepLink>('recipeStepLinkInfo').clear();
      Hive.box<RecipeStepLink>('recipeStepLinkInfo').addAll(recipeStepLink);

      // recipeStepLinkBox.clear();
      // recipeStepLinkBox.addAll(recipeStepLink);
      return recipeStepLink;
    } else {
      throw Exception('Failed to fetch recipe ingredients');
    }
  }
}

Future<List<RecipeStep>> fetchRecipeStep() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  // final Box<RecipeStep> recipeStepBox = Hive.box<RecipeStep>('recipeStep');

  if (connectivityResult == ConnectivityResult.none) {
    return getLocalDataRecipeStep();
  } else {
    String apiUrl = 'https://foodapi.dzolotov.tech/recipe_step';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      // var bb = measureUnit
      //     .firstWhere((element) => element.id == element.measureUnit.id)
      //     .id;
      List<RecipeStep> recipeStep = data
          // .where((recipeId) => recipeId['recipe']['id'] == ricepiIdd)
          .map((e) => RecipeStep.fromJson(e))
          .toList();

      // Добавление данных в базу Hive

      Hive.box<RecipeStep>('recipeStepInfo').clear();
      Hive.box<RecipeStep>('recipeStepInfo').addAll(recipeStep);
      // recipeStepBox.clear();
      // recipeStepBox.addAll(recipeStep);
      return recipeStep;
    } else {
      throw Exception('Failed to fetch recipe ingredients');
    }
  }
}

List<MeasureUnit> getLocalDataMeasureUnit() {
  return Hive.box<MeasureUnit>('measureUnitBox').values.toList();
}

Future<List<MeasureUnit>> fetchIngredientsMeasureUnit() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  final Box<MeasureUnit> measureUnitBox =
      Hive.box<MeasureUnit>('measureUnitBox');
  if (connectivityResult == ConnectivityResult.none) {
    return getLocalDataMeasureUnit();
  } else {
    String apiUrl = 'https://foodapi.dzolotov.tech/measure_unit';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<MeasureUnit> measureUnitInfo = data
          // .where((recipeId) => recipeId['recipe']['id'])
          .map((e) =>
              MeasureUnit(id: e['id'], one: 'one', few: 'few', many: 'many'))
          .toList();

      // Добавление данных в базу Hive
      measureUnitBox.clear();
      measureUnitBox.addAll(measureUnitInfo);
      return measureUnitInfo;
    } else {
      throw Exception('Failed to fetch recipe ingredients');
    }
  }
}

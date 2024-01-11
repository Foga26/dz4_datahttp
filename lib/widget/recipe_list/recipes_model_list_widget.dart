import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dz_2/resources/remote_ingredient.dart';
import 'package:dz_2/widget/recipe_info_widget/recipe_step_link.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

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
    var one = reader.readString();
    var few = reader.readString();
    var many = reader.readString();
    return MeasureUnit(
      id: id,
      one: one,
      few: few,
      many: many,
    );
  }

  @override
  void write(BinaryWriter writer, MeasureUnit obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.one);
    writer.writeString(obj.few);
    writer.writeString(obj.many);
  }
}

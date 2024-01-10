import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dz_2/resources/remote_ingredient.dart';

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

// Future<List<MeasureUnit>> fetchMeasureUnit() async {
//   // Проверка подключения к Интернету
//   var connectivityResult = await (Connectivity().checkConnectivity());

//   if (connectivityResult == ConnectivityResult.none) {
//     return getLocalDataMeasureUnit();
//   } else {
//     final response =
//         await http.get(Uri.parse('https://foodapi.dzolotov.tech/measure_unit'));
//     if (response.statusCode == 200) {
//       var data = json.decode(response.body) as List;

//       // data['categories'] as List;
//       List<MeasureUnit> result =
//           data.map((recipeingr) => MeasureUnit.fromJson(recipeingr)).toList();
//       Hive.box<MeasureUnit>('measureunit').clear();
//       Hive.box<MeasureUnit>('measureunit').addAll(result);
//       return result;
//     } else {
//       throw Exception('Failed to load categories');
//     }
//   }
// }

// List<MeasureUnit> getLocalDataMeasureUnit() {
//   return Hive.box<MeasureUnit>('measureunit').values.toList();
// }

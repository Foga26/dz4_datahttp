import 'package:json_annotation/json_annotation.dart';

import 'package:dz_2/widget/recipe_list/recipes_model_list_widget.dart';

part 'remote_ingredient.g.dart';

@JsonSerializable(explicitToJson: true)
class Ingredient {
  int id;
  String name;
  double caloriesForUnit;
  List<MeasureUnit> measureUnit;
  Ingredient({
    required this.id,
    required this.name,
    required this.caloriesForUnit,
    required this.measureUnit,
  });
  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MeasureUnit {
  int id;
  String one;
  String few;
  String many;
  MeasureUnit({
    required this.id,
    required this.one,
    required this.few,
    required this.many,
  });
  factory MeasureUnit.fromJson(Map<String, dynamic> json) =>
      _$MeasureUnitFromJson(json);

  Map<String, dynamic> toJson() => _$MeasureUnitToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RecipeIngridient {
  int id;
  int count;
  List<Ingredient> ingredient;
  List<RecipeInfoList> recipe;
  RecipeIngridient({
    required this.id,
    required this.count,
    required this.ingredient,
    required this.recipe,
  });
  factory RecipeIngridient.fromJson(Map<String, dynamic> json) =>
      _$RecipeIngridientFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeIngridientToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RecipeInfoList {
  final int id;
  final String name;
  final String photo;
  final int duration;

  RecipeInfoList(
      {required this.id,
      required this.name,
      required this.photo,
      required this.duration});
  factory RecipeInfoList.fromJson(Map<String, dynamic> json) =>
      _$RecipeInfoListFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeInfoListToJson(this);
}

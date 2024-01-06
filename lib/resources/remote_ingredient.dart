// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'remote_ingredient.g.dart';

@JsonSerializable(explicitToJson: true)
class Ingredient {
  final int id;
  final String name;
  final double caloriesForUnit;
  // @JsonKey(name: 'measureUnit')
  final List<MeasureUnit> measureUnit;
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
  final int id;
  final String one;
  final String few;
  final String many;
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
  final int id;
  final int count;
  @JsonKey(name: 'ingredient')
  final Ingredient ingredient;
  @JsonKey(name: 'recipe')
  final RecipeInfoList recipe;
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

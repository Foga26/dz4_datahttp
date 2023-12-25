import 'package:json_annotation/json_annotation.dart';
part 'recipe_ingr.g.dart';

@JsonSerializable()
class RecipeIngr {
  int id;
  int count;
  Map<String, dynamic> ingredient;
  Map<String, dynamic> recipe;
  RecipeIngr({
    required this.id,
    required this.count,
    required this.ingredient,
    required this.recipe,
  });
  factory RecipeIngr.fromJson(Map<String, dynamic> json) =>
      _$RecipeIngrFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeIngrToJson(this);
}

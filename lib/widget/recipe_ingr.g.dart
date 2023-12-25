// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_ingr.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeIngr _$RecipeIngrFromJson(Map<String, dynamic> json) => RecipeIngr(
      id: json['id'] as int,
      count: json['count'] as int,
      ingredient: json['ingredient'] as Map<String, dynamic>,
      recipe: json['recipe'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$RecipeIngrToJson(RecipeIngr instance) =>
    <String, dynamic>{
      'id': instance.id,
      'count': instance.count,
      'ingredient': instance.ingredient,
      'recipe': instance.recipe,
    };

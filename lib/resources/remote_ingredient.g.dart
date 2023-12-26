// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) => Ingredient(
      id: json['id'] as int,
      name: json['name'] as String,
      caloriesForUnit: (json['caloriesForUnit'] as num).toDouble(),
      measureUnit: (json['measureUnit'] as List<dynamic>)
          .map((e) => MeasureUnit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'caloriesForUnit': instance.caloriesForUnit,
      'measureUnit': instance.measureUnit.map((e) => e.toJson()).toList(),
    };

MeasureUnit _$MeasureUnitFromJson(Map<String, dynamic> json) => MeasureUnit(
      id: json['id'] as int,
      one: json['one'] as String,
      few: json['few'] as String,
      many: json['many'] as String,
    );

Map<String, dynamic> _$MeasureUnitToJson(MeasureUnit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'one': instance.one,
      'few': instance.few,
      'many': instance.many,
    };

RecipeIngridient _$RecipeIngridientFromJson(Map<String, dynamic> json) =>
    RecipeIngridient(
      id: json['id'] as int,
      count: json['count'] as int,
      ingredient: (json['ingredient'])
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      recipe: (json['recipe'] as List<dynamic>)
          .map((e) => RecipeInfoList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecipeIngridientToJson(RecipeIngridient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'count': instance.count,
      'ingredient': instance.ingredient.map((e) => e.toJson()).toList(),
      'recipe': instance.recipe.map((e) => e.toJson()).toList(),
    };

RecipeInfoList _$RecipeInfoListFromJson(Map<String, dynamic> json) =>
    RecipeInfoList(
      id: json['id'] as int,
      name: json['name'] as String,
      photo: json['photo'] as String,
      duration: json['duration'] as int,
    );

Map<String, dynamic> _$RecipeInfoListToJson(RecipeInfoList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photo': instance.photo,
      'duration': instance.duration,
    };

import 'package:hive/hive.dart';

part 'local_data.g.dart';

@HiveType(typeId: 0)
class RecipeIngredientLocal extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int count;

  @HiveField(2)
  final IngredientLocal ingredient;

  @HiveField(3)
  final int recipeId;

  RecipeIngredientLocal({
    required this.id,
    required this.count,
    required this.ingredient,
    required this.recipeId,
  });
}

@HiveType(typeId: 1)
class IngredientLocal extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double caloriesForUnit;

  @HiveField(3)
  final MeasureUnitLocal measureUnit;

  IngredientLocal({
    required this.id,
    required this.name,
    required this.caloriesForUnit,
    required this.measureUnit,
  });
}

@HiveType(typeId: 2)
class MeasureUnitLocal extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String one;

  @HiveField(2)
  final String few;

  @HiveField(3)
  final String many;

  MeasureUnitLocal({
    required this.id,
    required this.one,
    required this.few,
    required this.many,
  });
}

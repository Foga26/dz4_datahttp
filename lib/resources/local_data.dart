import 'package:hive/hive.dart';

part 'local_data.g.dart';

@HiveType(typeId: 0)
class RecipeIngredient extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int count;

  @HiveField(2)
  final Ingredient ingredient;

  @HiveField(3)
  final int recipeId;

  RecipeIngredient({
    required this.id,
    required this.count,
    required this.ingredient,
    required this.recipeId,
  });
}

@HiveType(typeId: 1)
class Ingredient extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int caloriesForUnit;

  @HiveField(3)
  final MeasureUnit measureUnit;

  Ingredient({
    required this.id,
    required this.name,
    required this.caloriesForUnit,
    required this.measureUnit,
  });
}

@HiveType(typeId: 2)
class MeasureUnit extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String one;

  @HiveField(2)
  final String few;

  @HiveField(3)
  final String many;

  MeasureUnit({
    required this.id,
    required this.one,
    required this.few,
    required this.many,
  });
}

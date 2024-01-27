// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeIngredientLocalAdapter extends TypeAdapter<RecipeIngredientLocal> {
  @override
  final int typeId = 0;

  @override
  RecipeIngredientLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeIngredientLocal(
      id: fields[0] as int,
      count: fields[1] as int,
      ingredient: fields[2] as IngredientLocal,
      recipeId: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeIngredientLocal obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.count)
      ..writeByte(2)
      ..write(obj.ingredient)
      ..writeByte(3)
      ..write(obj.recipeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeIngredientLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IngredientLocalAdapter extends TypeAdapter<IngredientLocal> {
  @override
  final int typeId = 1;

  @override
  IngredientLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IngredientLocal(
      id: fields[0] as int,
      name: fields[1] as String,
      caloriesForUnit: fields[2] as double,
      measureUnit: fields[3] as MeasureUnitLocal,
    );
  }

  @override
  void write(BinaryWriter writer, IngredientLocal obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.caloriesForUnit)
      ..writeByte(3)
      ..write(obj.measureUnit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MeasureUnitLocalAdapter extends TypeAdapter<MeasureUnitLocal> {
  @override
  final int typeId = 2;

  @override
  MeasureUnitLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeasureUnitLocal(
      id: fields[0] as int,
      one: fields[1] as String,
      few: fields[2] as String,
      many: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MeasureUnitLocal obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.one)
      ..writeByte(2)
      ..write(obj.few)
      ..writeByte(3)
      ..write(obj.many);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasureUnitLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecipeInfoListLocalAdapter extends TypeAdapter<RecipeInfoListLocal> {
  @override
  final int typeId = 3;

  @override
  RecipeInfoListLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeInfoListLocal(
      id: fields[0] as int,
      name: fields[1] as String,
      photo: fields[2] as String,
      duration: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeInfoListLocal obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.photo)
      ..writeByte(3)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeInfoListLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class RecipeStepLink {
  final int id;
  final int number;
  final int recipeId;
  final RecipeStep stepId;
  RecipeStepLink({
    required this.id,
    required this.number,
    required this.recipeId,
    required this.stepId,
  });

  RecipeStepLink copyWith({
    int? id,
    int? number,
    int? recipeId,
    RecipeStep? stepId,
  }) {
    return RecipeStepLink(
      id: id ?? this.id,
      number: number ?? this.number,
      recipeId: recipeId ?? this.recipeId,
      stepId: stepId ?? this.stepId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'recipeId': recipeId,
      'stepId': stepId.toMap(),
    };
  }

  factory RecipeStepLink.fromMap(Map<String, dynamic> map) {
    return RecipeStepLink(
      id: map['id'] as int,
      number: map['number'] as int,
      recipeId: map['recipeId'] as int,
      stepId: RecipeStep.fromMap(map['stepId'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeStepLink.fromJson(String source) =>
      RecipeStepLink.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RecipeStepLink(id: $id, number: $number, recipeId: $recipeId, stepId: $stepId)';
  }

  @override
  bool operator ==(covariant RecipeStepLink other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.number == number &&
        other.recipeId == recipeId &&
        other.stepId == stepId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ number.hashCode ^ recipeId.hashCode ^ stepId.hashCode;
  }
}

class RecipeStep {
  final int id;
  final String name;
  final int duration;
  RecipeStep({
    required this.id,
    required this.name,
    required this.duration,
  });

  RecipeStep copyWith({
    int? id,
    String? name,
    int? duration,
  }) {
    return RecipeStep(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'duration': duration,
    };
  }

  factory RecipeStep.fromMap(Map<String, dynamic> map) {
    return RecipeStep(
      id: map['id'] as int,
      name: map['name'] as String,
      duration: map['duration'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeStep.fromJson(String source) =>
      RecipeStep.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RecipeStep(id: $id, name: $name, duration: $duration)';

  @override
  bool operator ==(covariant RecipeStep other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.duration == duration;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ duration.hashCode;
}

class RecipeStepAdapter extends TypeAdapter<RecipeStep> {
  @override
  final typeId = 4;

  @override
  RecipeStep read(BinaryReader reader) {
    var id = reader.readInt();
    var name = reader.readString();

    var duration = reader.readInt();

    return RecipeStep(
      id: id,
      name: name,
      duration: duration,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeStep obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);

    writer.writeInt(obj.duration);
  }
}

class RecipeStepLinkAdapter extends TypeAdapter<RecipeStepLink> {
  @override
  final typeId = 5;

  @override
  RecipeStepLink read(BinaryReader reader) {
    var id = reader.readInt();
    var number = reader.readInt();
    var recipeId = reader.readInt();
    var stepId = reader.read();
    return RecipeStepLink(
      id: id,
      number: number,
      recipeId: recipeId,
      stepId: stepId,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeStepLink obj) {
    writer.writeInt(obj.id);
    writer.writeInt(obj.number);
    writer.writeInt(obj.recipeId);
    writer.write(obj.stepId);
  }
}

import 'package:otusrecipe/widget/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeIngredientList extends StatelessWidget {
  RecipeIngredientList({super.key});
  final List<Map<String, dynamic>> string = [
    {"id": 1, "one": "штука", "few": "штуки", "many": "штук"},
    {"id": 2, "one": "грамм", "few": "грамма", "many": "граммов"},
    {"id": 3, "one": "банка", "few": "банки", "many": "банок"},
    {"id": 4, "one": "коробка", "few": "коробки", "many": "коробок"},
    {
      "id": 5,
      "one": "чайная ложка",
      "few": "чайных ложки",
      "many": "чайных ложек"
    },
    {
      "id": 6,
      "one": "столовая ложка",
      "few": "столовых ложки",
      "many": "столовых ложек"
    },
    {"id": 7, "one": "миллилитр", "few": "миллилитра", "many": "миллилитров"},
    {"id": 8, "one": "по вкусу", "few": "по вкусу", "many": "по вкусу"},
    {"id": 9, "one": "зубчик", "few": "зубчика", "many": "зубчиков"},
    {"id": 10, "one": "головка", "few": "головки", "many": "головок"},
    {"id": 11, "one": "щепотка", "few": "щепотки", "many": "щепоток"},
    {"id": 12, "one": "килограмм", "few": "килограмма", "many": "килограммов"}
  ];

  String getUnit(int id, int quantity, List<Map<String, dynamic>> units) {
    for (var unit in units.where((measureUnit) => measureUnit['id'] == id)) {
      if (quantity == 1) {
        return unit['one'];
      } else if (quantity >= 2 && quantity <= 4) {
        return unit['few'];
      } else {
        return unit['many'];
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    var model = context.watch<RecipesIngredientListModel>();
    return Row(
      children: [
        SizedBox(
            width: 200,
            child: model.recipeInfoList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: model.recipeInfoList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(
                          ' ${model.recipeInfoList[index].ingredientId.name}',
                          style: const TextStyle(
                              height: 2.1,
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w400));
                    })),
        SizedBox(
            width: 135,
            child: model.recipeInfoList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: model.recipeInfoList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(
                          ' ${model.recipeInfoList[index].count}  ${getUnit(model.igredientListModel[index].measureUnit.id, model.recipeInfoList[index].count, string)}'
                          // '${getUnit(ingredientr[index].measureUnit.id, ingredient.count, string)}',
                          ,
                          style: const TextStyle(
                              height: 2.1,
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w400));
                    })),
      ],
    );
  }
}

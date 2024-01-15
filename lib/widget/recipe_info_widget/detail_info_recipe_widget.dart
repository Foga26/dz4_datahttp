// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dz_2/resources/remote_ingredient.dart';

import 'package:dz_2/widget/state_of_cook.dart';

import 'package:dz_2/widget/model.dart';
import 'package:dz_2/widget/recipe_info_widget/recipe_ingredient_list.dart';
import 'package:dz_2/widget/recipe_info_widget/recipe_step_link.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:rive/rive.dart';
import 'package:dz_2/resources/app_color.dart';
import 'package:dz_2/resources/custumicon.dart';
import 'package:dz_2/widget/recipe_info_widget/step_cook_widget.dart';

import '../comment_widget.dart';

class DetailInfoRecipeWidget extends StatefulWidget {
  final String id;
  final String name;
  final String photo;
  final String duration;

  DetailInfoRecipeWidget({
    Key? key,
    required this.id,
    required this.name,
    required this.photo,
    required this.duration,
  }) : super(key: key);

  @override
  State<DetailInfoRecipeWidget> createState() => _DetailInfoRecipeWidgetState();
}

class _DetailInfoRecipeWidgetState extends State<DetailInfoRecipeWidget> {
  bool ingridientsHave = false;

  // Map<String, dynamic>? mealData;
  Map<String, dynamic>? mealDetails = {};

  List<String> instructions = [];
  List<bool> chekboxValues = [];
  List<Ingredient> ingredientr = [];
  List<MeasureUnit> measureUnitInfo = [];
  List<RecipeStep> recipeStep = [];
  var test = RecipesIngredientListModel();
  @override
  initState() {
    // fetchRecipeIngredients(int.parse(widget.id));
    // fetchIngredientsMeasureUnit();
    fetchRecipeStepLinks(int.parse(widget.id));
    test.loadRecipeList(int.parse(widget.id));

    fetchRecipeStep();
    // MeasureUnitModel().loadMeasureUnit();
    // getLocalDataIngr();
    super.initState();
  }

  bool isFavorite = true;
  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void toggleIngridients() {
    setState(() {
      ingridientsHave = true;
    });
  }

  List<RecipeStepLink> recipeStepLink = [];
  List<RecipeStepLink> getLocalDataRecipeStepLink() {
    return Hive.box<RecipeStepLink>('recipeStepLinkInfo').values.toList();
  }

  List<RecipeStep> getLocalDataRecipeStep() {
    return Hive.box<RecipeStep>('recipeStepInfo').values.toList();
  }

  Future<List<RecipeStepLink>> fetchRecipeStepLinks(
    ricepiIdd,
  ) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      return getLocalDataRecipeStepLink();
    } else {
      String apiUrl = 'https://foodapi.dzolotov.tech/recipe_step_link';

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        await fetchRecipeStep();
        List<dynamic> data = jsonDecode(response.body);
        // var bb = measureUnit
        //     .firstWhere((element) => element.id == element.measureUnit.id)
        //     .id;
        recipeStepLink = data
            .where((recipeId) => recipeId['recipe']['id'] == ricepiIdd)
            .map((e) => RecipeStepLink(
                id: e['id'],
                number: e['number'],
                recipeId: e['recipe']['id'],
                stepId: RecipeStep(
                    id: e['step']['id'],
                    name: recipeStep
                        .firstWhere((step) => step.id == e['step']['id'])
                        .name,
                    duration: recipeStep
                        .firstWhere((step) => step.id == e['step']['id'])
                        .duration)))
            .toList();
        setState(() {});

        // Добавление данных в базу Hive
        Hive.box<RecipeStepLink>('recipeStepLinkInfo').clear();
        Hive.box<RecipeStepLink>('recipeStepLinkInfo').addAll(recipeStepLink);

        // recipeStepLinkBox.clear();
        // recipeStepLinkBox.addAll(recipeStepLink);
        return recipeStepLink;
      } else {
        throw Exception('Failed to fetch recipe ingredients');
      }
    }
  }

  Future<List<RecipeStep>> fetchRecipeStep() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    // final Box<RecipeStep> recipeStepBox = Hive.box<RecipeStep>('recipeStep');

    if (connectivityResult == ConnectivityResult.none) {
      return getLocalDataRecipeStep();
    } else {
      String apiUrl = 'https://foodapi.dzolotov.tech/recipe_step';

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        // var bb = measureUnit
        //     .firstWhere((element) => element.id == element.measureUnit.id)
        //     .id;
        recipeStep = data
            // .where((recipeId) => recipeId['recipe']['id'] == ricepiIdd)
            .map((e) => RecipeStep(
                  id: e['id'],
                  name: e['name'],
                  duration: e['duration'],
                ))
            .toList();
        setState(() {});

        // Добавление данных в базу Hive

        Hive.box<RecipeStep>('recipeStepInfo').clear();
        Hive.box<RecipeStep>('recipeStepInfo').addAll(recipeStep);
        // recipeStepBox.clear();
        // recipeStepBox.addAll(recipeStep);
        return recipeStep;
      } else {
        throw Exception('Failed to fetch recipe ingredients');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<Test>(context).isExpanded;
    var isTimerVisible = context.watch<Test>().isTimerVisible;
    //  Provider.of<Test>(context).isTimerVisible;

    chekboxValues = List<bool>.filled(recipeStepLink.length, false);

    final stepCook = StepCookWidget(
      stepcookInfo: recipeStepLink,
      duration: recipeStepLink,
      chekValues: chekboxValues,
    );

    if (widget.name.isEmpty) {
      return const Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Loading...'),
          SizedBox(
            height: 15,
          ),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ));
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: isTimerVisible
              ? const Size.fromHeight(120)
              : const Size.fromHeight(75),
          child: AppBar(
            flexibleSpace: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 60,
                  ),
                  child: Text(
                    'Рецепт',
                    style: TextStyle(
                        color: ColorApp.textColorDarkGreen, fontSize: 23),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Visibility(
                      visible: isTimerVisible,
                      child: Container(
                        height: isTimerVisible ? 50 : 0,
                        width: isTimerVisible ? double.infinity : 0,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isTimerVisible
                              ? ColorApp.textColorGreen
                              : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 90),
                          child: Row(
                            children: [
                              Text(
                                "Таймер",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: isTimerVisible
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 80),
                                child: Text(
                                  '${widget.duration}',
                                  style: TextStyle(
                                    color: isTimerVisible
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              ],
            ),
            backgroundColor:
                isTimerVisible ? ColorApp.textColorGreen : Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            toolbarHeight: 50,
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: Icon(CustomIcons.megafone),
              ),
            ],
            centerTitle: true,
          ),
        ),
        body: CustomScrollView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                (SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 24.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: SizedBox(
                                height: 45,
                                width: 45,
                                child: IconButton(
                                  icon: isFavorite
                                      ? const Icon(
                                          Icons.favorite,
                                          size: 25,
                                          color: Colors.black,
                                        )
                                      : const RiveAnimation.asset(
                                          'assets/heart.riv'),
                                  onPressed: toggleFavorite,
                                  iconSize: 24.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 5.43, left: 17),
                            child:
                                Icon(Icons.watch_later_outlined, size: 16.32),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.41, left: 10),
                            child: Text(
                              '${widget.duration} минут',
                              style: const TextStyle(
                                  color: ColorApp.textColorGreen, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 15, right: 15),
                          child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              child: Image.network(
                                widget.photo,
                              ))),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, left: 16),
                        child: Text('Ингредиенты',
                            style: TextStyle(
                                color: ColorApp.textColorDarkGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 15,
                          left: 25,
                          right: 25,
                        ),
                        child: Container(
                          // height: 400,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: ingridientsHave
                                    ? ColorApp.textColorGreen
                                    : ColorApp.colorGrey,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              shape: BoxShape.rectangle,
                              color: Colors.transparent),
                          child: SizedBox(
                            width: double.infinity,
                            // height: 297,
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 0, left: 1),
                                child: ChangeNotifierProvider(
                                    create: (context) => test,
                                    child: RecipeIngredientList())),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 232,
                            height: 48,
                            child: TextButton(
                                style: ButtonStyle(
                                  side: const MaterialStatePropertyAll(
                                      BorderSide(
                                          color: ColorApp.textColorDarkGreen,
                                          width: 3)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  )),
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.white,
                                  ),
                                ),
                                onPressed: toggleIngridients,
                                child: const Text(
                                  'Проверить наличие',
                                  style: TextStyle(
                                      color: ColorApp.textColorDarkGreen),
                                )),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 15),
                        child: Text('Шаги приготовления',
                            style: TextStyle(
                                color: ColorApp.textColorDarkGreen,
                                fontWeight: FontWeight.w500,
                                fontSize: 16)),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: stepCook),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: SizedBox(
                            width: 232,
                            height: 48,
                            child: TextButton(
                                onPressed: () =>
                                    Provider.of<Test>(context, listen: false)
                                        .gokok(),
                                style: context.watch<Test>().kok
                                    ? ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          side: const BorderSide(
                                              width: 4,
                                              color:
                                                  ColorApp.textColorDarkGreen),
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        )),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Colors.white,
                                        ))
                                    : ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        )),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          const Color(0xff165932),
                                        ),
                                      ),
                                child: context.watch<Test>().kok
                                    ? const Text('Закончить готовить',
                                        style: TextStyle(
                                            color: ColorApp.textColorDarkGreen))
                                    : const Text('Начать готовить',
                                        style: TextStyle(color: Colors.white))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 35,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          color: ColorApp.colorGrey,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 25,
                        ),
                        child: CommentScreen(),
                      )
                    ],
                  ),
                ))
              ]))
            ]));
  }
}

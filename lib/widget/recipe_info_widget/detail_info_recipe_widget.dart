// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import 'package:dz_2/resources/app_color.dart';
import 'package:dz_2/resources/custumicon.dart';
import 'package:dz_2/resources/remote_ingredient.dart';
import 'package:dz_2/widget/recipe_info_widget/step_cook_widget.dart';
import 'package:dz_2/widget/recipe_info_widget/recipe_ingredient.dart';

import '../changenotif.dart';
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
  List<dynamic> ingredientr = [];
  var test;
  @override
  initState() {
    fetchRecipeIngredients(int.parse(widget.id));
    fetchIngredients();
    // getLocalDataIngr();
    super.initState();
  }

  List<RecipeIngredientr> getLocalDataIngr() {
    return Hive.box<RecipeIngredientr>('recipeIngredientInfo').values.toList();
  }

  List<RecipeIngredientr> recipeIngredients = [];
  Future<List<RecipeIngredientr>> fetchRecipeIngredients(
    ricepiIdd,
  ) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    // final Box<RecipeIngredientr> recipeIngredientBox =
    //     Hive.box<RecipeIngredientr>('recipeIngredientInfo');
    if (connectivityResult == ConnectivityResult.none) {
      return getLocalDataIngr();
    } else {
      String apiUrl = 'https://foodapi.dzolotov.tech/recipe_ingredient';
      String apiIngredientUrl = 'https://foodapi.dzolotov.tech/ingredient';
      final responseIngr = await http.get(Uri.parse(apiIngredientUrl));
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<dynamic> dataIngr = jsonDecode(responseIngr.body);
        // final ingredientr = dataIngr.firstWhere((i) => i['id'] == e['ingredient']['id']);
        // final ingredientr = dataIngr
        //     // .where((recipeId) => recipeId['recipe']['id'])
        //     .map((e) => Ingredientr(
        //           id: e['id'],
        //           name: e['name'],
        //           caloriesForUnit: e['caloriesForUnit'],
        //           measureUnit: e['measureUnit']['id'],
        //         ))
        //     .toList();

        recipeIngredients = data
            .where((recipeId) => recipeId['recipe']['id'] == ricepiIdd)
            .map((e) => RecipeIngredientr(
                  id: e['id'],
                  count: e['count'],
                  ingredientId: Ingredientr(
                      id: e['ingredient']['id'],
                      name: ingredientr
                          .firstWhere((ingredient) =>
                              ingredient.id == e['ingredient']['id'])
                          .name,
                      caloriesForUnit: 0,
                      measureUnit: 0),
                  recipeId: e['recipe']['id'],
                ))
            .toList();
        setState(() {});

        // Добавление данных в базу Hive
        // recipeIngredientBox.clear();
        // recipeIngredientBox.addAll(recipeIngredients);
        return recipeIngredients;
      } else {
        throw Exception('Failed to fetch recipe ingredients');
      }
    }
  }

  Future<List<dynamic>> fetchIngredients() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    // final Box<Ingredientr> recipeIngredientBox =
    //     Hive.box<Ingredientr>('recipeIngredientInfo');
    // if (connectivityResult == ConnectivityResult.none) {
    //   return getLocalDataIngr();
    // } else {
    String apiUrl = 'https://foodapi.dzolotov.tech/ingredient';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      ingredientr = data
          // .where((recipeId) => recipeId['recipe']['id'])
          .map((e) => Ingredientr(
                id: e['id'],
                name: e['name'],
                caloriesForUnit: e['caloriesForUnit'],
                measureUnit: e['measureUnit']['id'],
              ))
          .toList();
      setState(() {});

      // Добавление данных в базу Hive
      // recipeIngredientBox.clear();
      // recipeIngredientBox.addAll(ingredientr);
      return ingredientr;
    } else {
      throw Exception('Failed to fetch recipe ingredients');
    }
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

  @override
  Widget build(BuildContext context) {
    var isExpanded = Provider.of<Test>(context).isExpanded;
    var isTimerVisible = Provider.of<Test>(context).isTimerVisible;
    final strInstructions =
        mealDetails?['strInstructions'].toString() ?? ''.toString();
    instructions = strInstructions.split("\r\n");
    chekboxValues = List<bool>.filled(instructions.length, false);

    // var testik = RecipeIngredientr(
    //     id: 0, count: 0, ingredientId: 0, recipeId: widget.mealId);

    final stepCook = StepCookWidget(
      stepcookInfo: instructions,
      stepNumber: 0,
      chekValues: chekboxValues,
    );

    // var ingridients = Text(
    //   '${mealDetails?['strIngredient1']}\n${mealDetails?['strIngredient2']}\n${mealDetails?['strIngredient3']}\n${mealDetails?['strIngredient4']}\n${mealDetails?['strIngredient5']}\n${mealDetails?['strIngredient6']}\n${mealDetails?['strIngredient7']}\n${mealDetails?['strIngredient8']}\n${mealDetails?['strIngredient9']}\n${mealDetails?['strIngredient10']}\n${mealDetails?['strIngredient11']}\n${mealDetails?['strIngredient12']}\n${mealDetails?['strIngredient13']}\n${mealDetails?['strIngredient14']}\n${mealDetails?['strIngredient15']}\n${mealDetails?['strIngredient16']}\n${mealDetails?['strIngredient17']}\n${mealDetails?['strIngredient18']}\n${mealDetails?['strIngredient19']}\n${mealDetails?['strIngredient20']}',
    //   style: const TextStyle(
    //       height: 2.1,
    //       color: Colors.grey,
    //       fontSize: 13,
    //       fontWeight: FontWeight.w400),
    // );
    // var properties = Text(
    //   '${mealDetails?['strMeasure1']}\n${mealDetails?['strMeasure2']}\n${mealDetails?['strMeasure3']}\n${mealDetails?['strMeasure4']}\n${mealDetails?['strMeasure5']}\n${mealDetails?['strMeasure6']}\n${mealDetails?['strMeasure7']}\n${mealDetails?['strMeasure8']}\n${mealDetails?['strMeasure9']}\n${mealDetails?['strMeasure10']}\n${mealDetails?['strMeasure11']}\n${mealDetails?['strMeasure12']}\n${mealDetails?['strMeasure13']}\n${mealDetails?['strMeasure14']}\n${mealDetails?['strMeasure15']}\n${mealDetails?['strMeasure16']}\n${mealDetails?['strMeasure17']}\n${mealDetails?['strMeasure18']}\n${mealDetails?['strMeasure19']}\n${mealDetails?['strMeasure20']}',
    //   style: const TextStyle(
    //       height: 2.1,
    //       color: Colors.grey,
    //       fontSize: 13,
    //       fontWeight: FontWeight.w400),
    // );

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
    return ChangeNotifierProvider(
        create: (BuildContext context) {
          Test();
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: isTimerVisible
                  ? const Size.fromHeight(120)
                  : const Size.fromHeight(75),
              child: AppBar(
                flexibleSpace: Column(
                  children: [
                    Padding(
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
                                      '38:59',
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
                                      fontWeight: FontWeight.w500,
                                      fontSize: 24.0),
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
                              Padding(
                                padding: EdgeInsets.only(top: 5.43, left: 17),
                                child: Icon(Icons.watch_later_outlined,
                                    size: 16.32),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4.41, left: 10),
                                child: Text(
                                  '${widget.duration} минут',
                                  style: TextStyle(
                                      color: ColorApp.textColorGreen,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 15, right: 15),
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
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
                                    // color: ingridientsHave
                                    //     ? ColorApp.textColorGreen
                                    //     : ColorApp.colorGrey,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  shape: BoxShape.rectangle,
                                  color: Colors.transparent),
                              child: SizedBox(
                                width: double.infinity,
                                // height: 297,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(right: 8, left: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: SizedBox(
                                              width: 280,
                                              child: widget.name.isEmpty
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator())
                                                  : ListView.builder(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          recipeIngredients
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Text(
                                                            ' ${recipeIngredients[index].ingredientId.name}',
                                                            style: const TextStyle(
                                                                height: 2.1,
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400));
                                                      }))),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: SizedBox(
                                            width: 50,
                                            child: widget.name.isEmpty
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator())
                                                : ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: recipeIngredients
                                                        .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      final ingredient =
                                                          recipeIngredients[
                                                              index];

                                                      return Text(
                                                          ' ${ingredient.count}',
                                                          style: const TextStyle(
                                                              height: 2.1,
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400));
                                                    })),
                                      ),
                                    ],
                                  ),
                                ),
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
                                              color:
                                                  ColorApp.textColorDarkGreen,
                                              width: 3)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all(
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
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [stepCook],
                              )),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: SizedBox(
                                width: 232,
                                height: 48,
                                child: TextButton(
                                    onPressed: Provider.of<Test>(context).gokok,
                                    style: Provider.of<Test>(context).kok
                                        ? ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  width: 4,
                                                  color: ColorApp
                                                      .textColorDarkGreen),
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
                                    child: Provider.of<Test>(context).kok
                                        ? const Text('Закончить готовить',
                                            style: TextStyle(
                                                color: ColorApp
                                                    .textColorDarkGreen))
                                        : const Text('Начать готовить',
                                            style: TextStyle(
                                                color: Colors.white))),
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
                ])));
  }
}

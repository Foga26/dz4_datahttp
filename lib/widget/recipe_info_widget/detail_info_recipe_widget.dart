// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import 'package:dz_2/resources/app_color.dart';
import 'package:dz_2/resources/custumicon.dart';
import 'package:dz_2/resources/remote_ingredient.dart';
import 'package:dz_2/widget/recipe_info_widget/step_cook_widget.dart';

import '../changenotif.dart';
import '../comment_widget.dart';

class DetailInfoRecipeWidget extends StatefulWidget {
  final String mealId;
  final String name;
  final String photo;
  final String duration;
  final List<String> testIngr;

  const DetailInfoRecipeWidget({
    Key? key,
    required this.mealId,
    required this.name,
    required this.photo,
    required this.duration,
    required this.testIngr,
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

  Column ingridientsListss(List<String> strings) {
    List<String> wordWidgetsss = [];
    for (String string in widget.testIngr) {
      List<String> words = string.split(',');

      for (String word in words) {
        {
          wordWidgetsss.add(word);
        }
      }
    }
    List<Widget> wordWidgets = wordWidgetsss
        .map((word) => Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                word,
                style: const TextStyle(
                    height: 2.1,
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w400),
              ),
            ))
        .toList();
    return Column(
      children: wordWidgets,
    );
  }

  // Future<void> loadData() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());

  //   // Если есть подключение к Интернету
  //   if (connectivityResult == ConnectivityResult.wifi ||
  //       connectivityResult == ConnectivityResult.mobile) {
  //     // String url = 'https://www.themealdb.com/api/json/v1/1/lookup.php?i=52772';
  //     // var response = await http.get(Uri.parse(url));
  //     final response = await http.get(Uri.parse(
  //         'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.mealId}'));
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);

  //       mealDetails = await data['meals'][0];

  //       // Сохранение данных из API в локальную базу данных
  //       final Box box = Hive.box('meals');
  //       await box.put(
  //         'data',
  //         mealDetails,
  //       );
  //     }
  //   } else {
  //     // Если нет подключения к Интернету, использовать локальные данные
  //     var box = Hive.box('meals');
  //     mealDetails =
  //         Map<String, dynamic>.from(box.get('data', defaultValue: 'data'));
  //   }

  //   setState(() {});
  // }

  @override
  initState() {
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

  @override
  Widget build(BuildContext context) {
    var isExpanded = Provider.of<Test>(context).isExpanded;
    var isTimerVisible = Provider.of<Test>(context).isTimerVisible;
    final strInstructions =
        mealDetails?['strInstructions'].toString() ?? ''.toString();
    instructions = strInstructions.split("\r\n");
    chekboxValues = List<bool>.filled(instructions.length, false);

    final stepCook = StepCookWidget(
      stepcookInfo: instructions,
      stepNumber: 0,
      chekValues: chekboxValues,
    );

    var ingridients = Text(
      '${mealDetails?['strIngredient1']}\n${mealDetails?['strIngredient2']}\n${mealDetails?['strIngredient3']}\n${mealDetails?['strIngredient4']}\n${mealDetails?['strIngredient5']}\n${mealDetails?['strIngredient6']}\n${mealDetails?['strIngredient7']}\n${mealDetails?['strIngredient8']}\n${mealDetails?['strIngredient9']}\n${mealDetails?['strIngredient10']}\n${mealDetails?['strIngredient11']}\n${mealDetails?['strIngredient12']}\n${mealDetails?['strIngredient13']}\n${mealDetails?['strIngredient14']}\n${mealDetails?['strIngredient15']}\n${mealDetails?['strIngredient16']}\n${mealDetails?['strIngredient17']}\n${mealDetails?['strIngredient18']}\n${mealDetails?['strIngredient19']}\n${mealDetails?['strIngredient20']}',
      style: const TextStyle(
          height: 2.1,
          color: Colors.grey,
          fontSize: 13,
          fontWeight: FontWeight.w400),
    );
    var properties = Text(
      '${mealDetails?['strMeasure1']}\n${mealDetails?['strMeasure2']}\n${mealDetails?['strMeasure3']}\n${mealDetails?['strMeasure4']}\n${mealDetails?['strMeasure5']}\n${mealDetails?['strMeasure6']}\n${mealDetails?['strMeasure7']}\n${mealDetails?['strMeasure8']}\n${mealDetails?['strMeasure9']}\n${mealDetails?['strMeasure10']}\n${mealDetails?['strMeasure11']}\n${mealDetails?['strMeasure12']}\n${mealDetails?['strMeasure13']}\n${mealDetails?['strMeasure14']}\n${mealDetails?['strMeasure15']}\n${mealDetails?['strMeasure16']}\n${mealDetails?['strMeasure17']}\n${mealDetails?['strMeasure18']}\n${mealDetails?['strMeasure19']}\n${mealDetails?['strMeasure20']}',
      style: const TextStyle(
          height: 2.1,
          color: Colors.grey,
          fontSize: 13,
          fontWeight: FontWeight.w400),
    );

    if (widget.mealId.isEmpty) {
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
                              height: 576,
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
                                width: 379,
                                // height: 297,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8, left: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 15),
                                                child: ingridientsListss(
                                                    widget.testIngr)),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: Text(''),
                                        ),
                                      ],
                                    ),
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

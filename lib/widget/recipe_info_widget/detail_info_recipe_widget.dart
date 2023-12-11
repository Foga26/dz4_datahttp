import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:dz_2/resources/app_color.dart';
import 'package:dz_2/resources/custumicon.dart';
import 'package:dz_2/widget/recipe_info_widget/step_cook_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../changenotif.dart';
import '../comment_widget.dart';
import 'package:rive/rive.dart';

class DetailInfoRecipeWidget extends StatefulWidget {
  const DetailInfoRecipeWidget({super.key});

  @override
  State<DetailInfoRecipeWidget> createState() => _DetailInfoRecipeWidgetState();
}

class _DetailInfoRecipeWidgetState extends State<DetailInfoRecipeWidget> {
  bool ingridientsHave = false;

  // Map<String, dynamic>? mealData;
  Map<String, dynamic>? meals;
  List<String> instructions = [];
  List<bool> chekboxValues = [];

  Future<void> loadData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    // Если есть подключение к Интернету
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      String url = 'https://www.themealdb.com/api/json/v1/1/lookup.php?i=52772';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        meals = data['meals'][0];

        // Сохранение данных из API в локальную базу данных
        final Box box = Hive.box('meals');
        await box.put(
          'data',
          meals,
        );
      }
    } else {
      // Если нет подключения к Интернету, использовать локальные данные
      var box = Hive.box('meals');
      meals = Map<String, dynamic>.from(box.get('data', defaultValue: 'data'));
    }

    setState(() {});
  }

  @override
  initState() {
    super.initState();

    loadData();
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
        meals?['strInstructions'].toString() ?? ''.toString();
    instructions = strInstructions.split("\r\n");
    chekboxValues = List<bool>.filled(instructions.length, false);

    final test = StepCookWidget(
      stepcookInfo: instructions,
      stepNumber: 0,
      chekValues: chekboxValues,
    );
    final properties = Text(
      '${meals?['strMeasure1']}\n${meals?['strMeasure2']}\n${meals?['strMeasure3']}\n${meals?['strMeasure4']}\n${meals?['strMeasure5']}\n${meals?['strMeasure6']}\n${meals?['strMeasure7']}\n${meals?['strMeasure8']}\n${meals?['strMeasure9']}',
      style: const TextStyle(
          height: 2.1,
          color: Colors.grey,
          fontSize: 13,
          fontWeight: FontWeight.w400),
    );

    final ingridients = Text(
      '• ${meals?['strIngredient1']}\n• ${meals?['strIngredient2']}\n• ${meals?['strIngredient3']}\n• ${meals?['strIngredient4']}\n• ${meals?['strIngredient5']}\n• ${meals?['strIngredient6']}\n• ${meals?['strIngredient7']}\n• ${meals?['strIngredient8']}\n• ${meals?['strIngredient9']}',
      style: const TextStyle(
        height: 1.9,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );

    if (meals == null) {
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
              preferredSize:
                  isTimerVisible ? Size.fromHeight(100) : Size.fromHeight(60),
              child: AppBar(
                flexibleSpace: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 60,
                      ),
                      child: const Text(
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
                            padding: EdgeInsets.all(10),
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
                              children: [
                                Text(
                                  meals?['strMeal'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 24.0),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
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
                                          : RiveAnimation.asset(
                                              'assets/heart.riv'),
                                      onPressed: toggleFavorite,
                                      iconSize: 24.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 5.43, left: 17),
                                child: Icon(Icons.watch_later_outlined,
                                    size: 16.32),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4.41, left: 10),
                                child: Text(
                                  '45 минут',
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
                                    meals?['strMealThumb'],
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
                              width: 395,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: ingridientsHave
                                        ? ColorApp.textColorGreen
                                        : ColorApp.colorGrey,
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
                                    top: 13,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: Column(
                                            children: [
                                              ingridients,
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: Column(
                                            children: [
                                              properties,
                                            ],
                                          ),
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
                                children: [test],
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

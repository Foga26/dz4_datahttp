<<<<<<< HEAD
import 'package:dz_2/resources/local_data.dart';
import 'package:dz_2/widget/state_of_cook.dart';
=======
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dz_2/resources/remote_ingredient.dart';

import 'package:dz_2/widget/state_of_cook.dart';

import 'package:dz_2/widget/model.dart';
import 'package:dz_2/widget/recipe_info_widget/recipe_ingredient_list.dart';
import 'package:dz_2/widget/recipe_info_widget/recipe_step_link.dart';
>>>>>>> 2281c50a63fa27e05d4e36a3cd4338a14c54e1b7
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:dz_2/resources/app_color.dart';
import 'package:dz_2/resources/custumicon.dart';

import 'package:dz_2/widget/model.dart';
import 'package:dz_2/widget/recipe_info_widget/recipe_ingredient_list.dart';
import 'package:dz_2/widget/recipe_info_widget/step_cook_widget.dart';
import '../comment_widget.dart';

class DetailInfoRecipeWidget extends StatefulWidget {
  final String id;
  final String name;
  final String photo;
  final String duration;

  const DetailInfoRecipeWidget({
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
  // Map<String, dynamic>? mealData;

  var test = RecipesIngredientListModel();
  var recipeStepModel = RecipeStepModel();
  var recipeModel = RecipesListModel();

  @override
  initState() {
    // fetchRecipeIngredients(int.parse(widget.id));
    // fetchIngredientsMeasureUnit();
    // fetchRecipeStepLinks(int.parse(widget.id));
    test.loadRecipeList(int.parse(widget.id));
    recipeStepModel.loadRecipeStepLink(int.parse(widget.id));

    // fetchRecipeStep();
    // MeasureUnitModel().loadMeasureUnit();
    // getLocalDataIngr();
    super.initState();
  }

  bool ingridientsHave = false;

  @override
  Widget build(BuildContext context) {
    // Provider.of<Test>(context).isExpanded;
    var isTimerVisible = context.watch<Test>().isTimerVisible;

    var isFavorite = Provider.of<RecipesListModel>(
      context,
    );
    var recipeInfoWidget = RecipeInfoListLocal(
        id: int.parse(widget.id),
        name: widget.name,
        photo: widget.photo,
        duration: int.parse(widget.duration));
    bool isFavor = Provider.of<RecipesListModel>(context, listen: false)
        .isFavorite(recipeInfoWidget);
    //  Provider.of<Test>(context).isTimerVisible;

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
                                  widget.duration,
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
                                  icon: isFavor
                                      ? const RiveAnimation.asset(
                                          'assets/heart.riv')
                                      : const Icon(
                                          Icons.favorite,
                                          size: 25,
                                          color: Colors.black,
                                        ),
                                  onPressed: () {
                                    if (isFavor) {
                                      isFavorite.removeFromFavorites(
                                          recipeInfoWidget);
                                    } else {
                                      isFavorite
                                          .addToFavorites(recipeInfoWidget);
                                    }
                                  },
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
                                onPressed: () => setState(() {
                                      ingridientsHave = true;
                                    }),
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
<<<<<<< HEAD
                          padding: const EdgeInsets.only(top: 20),
                          child: ChangeNotifierProvider(
                            create: ((context) => recipeStepModel),
                            child: StepCookWidget(
                              chekboxValues: const [
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                              ],
                            ),
                          )),
=======
                          padding: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: stepCook),
>>>>>>> 2281c50a63fa27e05d4e36a3cd4338a14c54e1b7
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

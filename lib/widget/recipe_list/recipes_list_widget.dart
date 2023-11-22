import 'package:dz_2/resources/main_navigation.dart';

import 'package:dz_2/widget/recipe_list/recipes_model_list_widget.dart';
import 'package:flutter/material.dart';
import '../../resources/app_color.dart';

class RecipesModelListWidget extends StatefulWidget {
  const RecipesModelListWidget({super.key});

  @override
  State<RecipesModelListWidget> createState() => _RecipesModelListWidgetState();
}

class _RecipesModelListWidgetState extends State<RecipesModelListWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorApp.backGroundColor,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(top: 45),
                child: Center(
                    child: FutureBuilder(
                        future: fetchData(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }

                          return ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Padding(
                                  padding: EdgeInsets.only(top: 24));
                            },
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              {
                                return Container(
                                  margin: EdgeInsets.only(left: 16, right: 16),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 0,
                                          offset: Offset(0, 3),
                                          blurRadius: 5)
                                    ],
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  width: 396,
                                  height: 136,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5),
                                        ),
                                        child: Image.network(
                                          snapshot
                                              .data![index].strCategoryThumb,
                                          width: 149,
                                          height: 136,
                                          // fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 165, top: 30),
                                        child: Flex(
                                            direction: Axis.vertical,
                                            children: [
                                              Text(
                                                (snapshot
                                                    .data![index].strCategory),
                                                style: const TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                maxLines: 2,
                                              ),
                                            ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 165, top: 60),
                                        child: Text(
                                          snapshot.data![index]
                                              .strCategoryDescription,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis),
                                          maxLines: 2,
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(top: 95, left: 165),
                                        child: Icon(
                                          Icons.watch_later_outlined,
                                          size: 16,
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(top: 94, left: 192),
                                        child: SizedBox(
                                          height: 19,
                                          child: Text(
                                            '45 минут',
                                            style: TextStyle(
                                                color: ColorApp.textColorGreen,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onTap: () => Navigator.pushNamed(
                                                context,
                                                // context, goToRecipeInfo

                                                MainNavigationRouteNames
                                                    .recipeInfoWidget)),
                                      )
                                    ],
                                  ),
                                );
                              }
                            },
                          );
                        })))));
  }
}

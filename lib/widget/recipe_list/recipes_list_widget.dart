import 'package:dz_2/widget/inherit_model.dart';
import 'package:dz_2/widget/model.dart';
import 'package:flutter/material.dart';
import 'package:dz_2/resources/main_navigation.dart';
import '../../resources/app_color.dart';

class RecipesListWidget extends StatelessWidget {
  RecipesListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = NotifierProvider.watch<RecipesListModel>(context);
    // var modelIngr = NotifierProvider.watch<RecipeIngridientModel>(context)
    //     ?.recipeIngridient;

    return Scaffold(
        backgroundColor: ColorApp.backGroundColor,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(top: 45),
                child: Center(
                    child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Padding(padding: EdgeInsets.only(top: 24));
                  },
                  itemCount: model?.recipeInfoList.length ?? 0,
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
                          borderRadius: BorderRadius.all(Radius.circular(5)),
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
                                model!.recipeInfoList[index].photo,
                                fit: BoxFit.fill,
                                width: 149,
                                height: 136,
                                // fit: BoxFit.fitHeight,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 165, top: 30),
                              child: Flex(direction: Axis.vertical, children: [
                                Text(
                                  (model.recipeInfoList[index].name),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                  maxLines: 1,
                                ),
                              ]),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 165, top: 60),
                              child: Text(
                                '${model.recipeInfoList[index].duration} минут',
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 2,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 95, left: 165),
                              child: Icon(
                                Icons.watch_later_outlined,
                                size: 16,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 94, left: 192),
                              child: SizedBox(
                                height: 19,
                                child: Text(
                                  '${model.recipeInfoList[index].duration} минут',
                                  style: TextStyle(
                                      color: ColorApp.textColorGreen,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () => Navigator.pushNamed(
                                          context,
                                          MainNavigationRouteNames
                                              .recipeInfoPage,
                                          arguments: {
                                            'id':
                                                model.recipeInfoList[index].id,
                                            'name': model
                                                .recipeInfoList[index].name,
                                            'duration': model
                                                .recipeInfoList[index].duration,
                                            'photo': model
                                                .recipeInfoList[index].photo,
                                          })),
                            )
                          ],
                        ),
                      );
                    }
                  },
                )))));
  }
}

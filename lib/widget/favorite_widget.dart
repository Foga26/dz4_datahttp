import 'package:otusrecipe/resources/local_data.dart';
import 'package:otusrecipe/resources/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteWidget extends StatelessWidget {
  const FavoriteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<RecipeInfoListLocal> favoritesBox =
        Hive.box<RecipeInfoListLocal>('favoritesrecipe');

    return Scaffold(
      body: WatchBoxBuilder(
        box: favoritesBox,
        builder: (BuildContext context, box) {
          if (box.isEmpty) {
            return Center(
              child: Text('No recipes found'),
            );
          } else {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final recipe = box.getAt(index) as RecipeInfoListLocal;
                return ListTile(
                  title: Text(recipe.name),
                  leading: Image.network(recipe.photo),
                  subtitle: Text('${recipe.duration.toString()} минут'),
                  onTap: () {
                    Navigator.pushNamed(
                        context, MainNavigationRouteNames.recipeInfoPage,
                        arguments: {
                          'id': recipe.id,
                          'name': recipe.name,
                          'duration': recipe.duration,
                          'photo': recipe.photo,
                        });
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

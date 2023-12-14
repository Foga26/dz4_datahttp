import 'package:flutter/material.dart';
import '../widget/auth_widget.dart';
import '../widget/inherit_model.dart';
import '../widget/main_screen/main_screen_model.dart';
import '../widget/main_screen/main_screen_widget.dart';
import '../widget/recipe_info_widget.dart';
import '../widget/recipe_info_widget/detail_info_recipe_widget.dart';
import '../widget/recipe_list/recipes_list_widget.dart';

abstract class MainNavigationRouteNames {
  static const mainPage = 'main';
  static const recipesPage = 'recipes';
  static const recipeInfoPage = 'recipeInfo';
  static const auth = 'auth';
  static const recipeInfoWidget = 'recipes/recipeInfoWidget';
}

class MainNavigation {
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.mainPage: ((context) => NotifierProvider(
        model: MainScreenModel(), child: const MainScreenwidget())),
    '/main': (context) => const MainScreenwidget(),
    '/recipes': (context) => const RecipesModelListWidget(),
    '/recipeInfo': (context) => DetailInfoRecipeWidget(),
    // '/recipeInfoPokeboul': (context) => const PokeboulInfoWidget(),
    '/auth': (context) => const AuthWidget(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.recipeInfoWidget:
        final arguments = settings.arguments;
        final recipeid = arguments is int ? arguments : 0;
        return PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            animation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            );
            if (animation.status == AnimationStatus.reverse) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            } else {
              return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child);
            }
          },
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return RecipeInfoWidget(recipeid: recipeid);
          },
        );
      default:
        const widget = Text('Navigation error');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}

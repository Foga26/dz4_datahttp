import 'package:otusrecipe/resources/local_data.dart';
import 'package:otusrecipe/resources/main_navigation.dart';
import 'package:otusrecipe/resources/remote_ingredient.dart';
import 'package:otusrecipe/widget/model.dart';
import 'package:otusrecipe/widget/recipe_info_widget/recipe_step_link.dart';
import 'package:otusrecipe/widget/recipe_list/recipes_model_list_widget.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:otusrecipe/widget/state_of_cook.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final appDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDirectory.path);
  // Инициализация Hive
  Hive.registerAdapter<RecipeInfoList>(RecipeListInfoAdapter());
  Hive.registerAdapter<RecipeIngridient>(RecipeIngridientListInfoAdapter());
  Hive.registerAdapter<RecipeStep>(RecipeStepAdapter());
  Hive.registerAdapter<RecipeStepLink>(RecipeStepLinkAdapter());
  Hive.registerAdapter<Ingredient>(IngridientListInfoAdapter());
  Hive.registerAdapter<MeasureUnit>(MeasureUnitAdapter());
  Hive.registerAdapter(RecipeInfoListLocalAdapter());

  await Hive.openBox<RecipeInfoListLocal>('favoritesRecipe');
  await Hive.openBox('recipeIngredientsBox');
  await Hive.openBox<RecipeInfoList>('recipe');
  await Hive.openBox<RecipeStep>('recipeStepInfo');
  await Hive.openBox<RecipeStepLink>('recipeStepLinkInfo');
  await Hive.openBox<Ingredient>('recipeIngredientInfo');
  await Hive.openBox<MeasureUnit>('measureUnitBox');
  await Hive.openBox<RecipeIngridient>('recipeIngredientInfoDetail');
  await Hive.openBox('imagesFromCam');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Test()),
        ChangeNotifierProvider(create: (context) => RecipesListModel()),
        ChangeNotifierProvider(create: (context) => RecipeStepModel()),
        // ChangeNotifierProvider(create: (context) => UserModel())
      ],
      child: MaterialApp(
        routes: mainNavigation.routes,
        initialRoute: MainNavigationRouteNames.mainPage,
        onGenerateRoute: mainNavigation.onGenerateRoute,
      ),
    );
  }
}

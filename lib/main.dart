import 'package:dz_2/resources/main_navigation.dart';
import 'package:dz_2/widget/recipe_list/recipes_model_list_widget.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:dz_2/widget/changenotif.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  // Инициализация Hive
  await Hive.initFlutter();

  // Регистрация адаптера Hive для модели данных
  Hive.registerAdapter<Category>(CategoryAdapter());
  WidgetsFlutterBinding.ensureInitialized();
  final appDirectory = await path_provider.getApplicationDocumentsDirectory();

  // Открытие Hive-коробки
  await Hive.openBox<Category>('categories');

  await Hive.openBox('meals');

  Hive.init(appDirectory.path);
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
      ],
      child: MaterialApp(
        routes: mainNavigation.routes,
        initialRoute: MainNavigationRouteNames.mainPage,
        onGenerateRoute: mainNavigation.onGenerateRoute,
      ),
    );
  }
}

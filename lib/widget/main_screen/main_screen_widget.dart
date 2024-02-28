import 'package:otusrecipe/resources/custumicon.dart';
import 'package:otusrecipe/widget/auth_widget.dart';
import 'package:otusrecipe/widget/favorite_widget.dart';
import 'package:otusrecipe/widget/inherit_model.dart';
import 'package:otusrecipe/widget/model.dart';
import 'package:otusrecipe/widget/recipe_list/recipes_list_widget.dart';
import 'package:otusrecipe/widget/state_of_cook.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../resources/app_color.dart';

class MainScreenwidget extends StatefulWidget {
  const MainScreenwidget({super.key});

  @override
  State<MainScreenwidget> createState() => _MainScreenwidgetState();
}

class _MainScreenwidgetState extends State<MainScreenwidget> {
  int _selectedTab = 0;
  var model = RecipesListModel();
  var test = RecipesIngredientListModel();

  void onSelectTab(int index) {
    if (_selectedTab == index) return;

    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void initState() {
    super.initState();
    model.loadRecipeList();
  }

  @override
  Widget build(BuildContext context) {
    var isAuth = context.watch<Test>().isAuth;
    List<Widget> _widgetOption = <Widget>[
      NotifierProvider(model: model, child: const RecipesListWidget()),
      AuthWidget(),
      FavoriteWidget(),
    ];
    if (model.recipeInfoList.isEmpty) {
      const CircularProgressIndicator();
    }
    return Scaffold(
      body: SafeArea(
        child: _widgetOption[_selectedTab],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab, // устанавливаем текущий индекс
        onTap: (index) {
          setState(() {
            _selectedTab = index; //изменяем текущий индекс при нажатии
          });
        },
        selectedItemColor: ColorApp.textColorGreen,
        items: isAuth
            ? const [
                BottomNavigationBarItem(
                  icon: Icon(CustomIcons.pizza),
                  label: 'Рецепты',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Вход',
                ),
              ]
            : const [
                BottomNavigationBarItem(
                  icon: Icon(CustomIcons.pizza),
                  label: 'Рецепты',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Аккаунт',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Избранное',
                ),
              ],
      ),
    );
  }
}

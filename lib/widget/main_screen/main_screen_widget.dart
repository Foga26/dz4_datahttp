import 'package:dz_2/resources/custumicon.dart';
import 'package:dz_2/widget/auth_widget.dart';
import 'package:dz_2/widget/inherit_model.dart';
import 'package:dz_2/widget/model.dart';
import 'package:dz_2/widget/recipe_list/recipes_list_widget.dart';
import 'package:flutter/material.dart';
import '../../resources/app_color.dart';

class MainScreenwidget extends StatefulWidget {
  const MainScreenwidget({super.key});

  @override
  State<MainScreenwidget> createState() => _MainScreenwidgetState();
}

class _MainScreenwidgetState extends State<MainScreenwidget> {
  int _selectedTab = 1;
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

    // modeltwo.loadRecipeList();

    // IngredientModel().loadRecipeList();

    // RecipeStepkModel().loadRecipeList();
    // MeasureUnitModel().loadRecipeList();

    // fetchMeasureUnit();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOption = <Widget>[
      NotifierProvider(model: model, child: const RecipesListWidget()),
      const AuthWidget(),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.pizza),
            label: 'Рецепты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Вход',
          ),
        ],
      ),
    );
  }
}

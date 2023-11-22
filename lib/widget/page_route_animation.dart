import 'package:dz_2/widget/recipe_list/recipes_list_widget.dart';
import 'package:flutter/material.dart';

// var goToRecipeInfo = PageRouteBuilder(
//   transitionDuration: Duration(milliseconds: 500),
//   transitionsBuilder: (BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     animation = CurvedAnimation(
//       parent: animation,
//       curve: Curves.easeOut,
//     );
//     return SlideTransition(
//       position: Tween<Offset>(
//         begin: const Offset(1.0, 0.0),
//         end: Offset.zero,
//       ).animate(animation),
//       child: child,
//     );
//   },
//   pageBuilder: (BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation) {
//     return DetailInfoRecipeWidget();
//   },
// );

var backToRecipesList = PageRouteBuilder(
  transitionDuration: Duration(milliseconds: 500),
  transitionsBuilder: (BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    animation = CurvedAnimation(parent: animation, curve: Curves.ease);

    return FadeTransition(opacity: animation, child: child);
  },
  pageBuilder: (BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return RecipesModelListWidget();
  },
);

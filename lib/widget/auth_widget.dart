import 'package:dz_2/resources/main_navigation.dart';
import 'package:dz_2/resources/remote_ingredient.dart';
import 'package:dz_2/widget/blutooth.dart';
import 'package:dz_2/widget/recipe_list/recipes_model_list_widget.dart';
import 'package:dz_2/widget/state_of_cook.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../resources/app_color.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({
    super.key,
  });

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  late User user;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  void _login(BuildContext context) {
    var isAuth = Provider.of<Test>(context, listen: false);
    String enteredUsername = usernameController.text;
    String enteredPassword = passwordController.text;

    if (enteredUsername == user.login && enteredPassword == user.password) {
      isAuth.isAuthChek();
      Navigator.pushNamed((context), MainNavigationRouteNames.mainPage);
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ошибка'),
            content: const Text('Не правильный логин или пароль'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var isAuth = Provider.of<Test>(context, listen: false);
    var isAuthFalse = context.watch<Test>().isAuth;
    final textFieldDecoration1 = InputDecoration(
        label: const Row(
          children: [
            Icon(
              Icons.person,
              color: Color(0xffc2c2c2),
            ),
            SizedBox(
              width: 13,
            ),
            Text(
              'логин',
              style: TextStyle(color: Color(0xffc2c2c2)),
            ),
          ],
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));
    final textFieldDecoration2 = InputDecoration(
        filled: true,
        fillColor: Colors.white,
        label: const Row(
          children: [
            Icon(
              Icons.lock,
              color: ColorApp.iconColor,
            ),
            SizedBox(
              width: 13,
            ),
            Text('пароль', style: TextStyle(color: ColorApp.iconColor)),
          ],
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));
    return isAuthFalse
        ? Center(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: ColorApp.textColorGreen,
                  child: const Padding(
                    padding: EdgeInsets.only(
                      top: 248,
                    ),
                    child: SizedBox(
                      width: 138,
                      height: 23,
                      child: Text(
                        'Otus.Food',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(top: 352, left: 98, right: 98),
                    child: SizedBox(
                      width: 232,
                      height: 48,
                      child: TextField(
                        decoration: textFieldDecoration1,
                        controller: usernameController,
                      ),
                    )),
                Padding(
                    padding:
                        const EdgeInsets.only(top: 416, left: 98, right: 98),
                    child: SizedBox(
                      width: 232,
                      height: 48,
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: textFieldDecoration2,
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                      top: 504,
                      left: 98,
                      right: 98,
                    ),
                    child: SizedBox(
                      width: 232,
                      height: 48,
                      child: TextButton(
                          onPressed: () async {
                            user = await fetchUser();

                            _login(context);
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            )),
                            backgroundColor: MaterialStateProperty.all(
                              ColorApp.textColorDarkGreen,
                            ),
                          ),
                          child: const Text(
                            'Войти',
                            style: TextStyle(color: Colors.white),
                          )),
                    )),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 640,
                    ),
                    child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Зарегистрироваться',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        )),
                  ),
                )
              ],
            ),
          )
        : Center(
            child: Column(
              children: [
                Flexible(child: ProfilePage()),
                TextButton(
                  onPressed: () {
                    isAuth.isAuthChek();
                  },
                  child: Text('Выход'),
                ),
              ],
            ),
          );
  }
}

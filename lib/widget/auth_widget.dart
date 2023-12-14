import 'package:flutter/material.dart';

import '../resources/app_color.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
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
  @override
  Widget build(BuildContext context) {
    return Center(
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
              padding: const EdgeInsets.only(top: 352, left: 98, right: 98),
              child: SizedBox(
                width: 232,
                height: 48,
                child: TextField(
                  decoration: textFieldDecoration1,
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(top: 416, left: 98, right: 98),
              child: SizedBox(
                width: 232,
                height: 48,
                child: TextField(
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
                    onPressed: () {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
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
    );
  }
}

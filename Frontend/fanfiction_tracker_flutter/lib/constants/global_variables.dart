import 'package:flutter/material.dart';

String uri = 'http://localhost:3000';

class GlobalVariables {
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromRGBO(69, 91, 190, 1),
      Color.fromRGBO(137, 153, 227, 1),
    ],
    stops: [0.5, 1.0],
  );

  static const secondaryColor = Color.fromRGBO(69, 91, 190, 1);
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundColor = Color(0xffebecee);
  static const selectedNavBarColor = Color.fromRGBO(69, 91, 190, 1);
  static const unselectedNavBarColor = Colors.black87;
}
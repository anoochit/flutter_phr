import 'package:flutter/material.dart';

final ThemeData themeData = ThemeData(
  primarySwatch: Colors.blue,
  canvasColor: Colors.grey.shade200,
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.black,
    backgroundColor: Colors.white,
    elevation: 1.0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
    ),
  ),
  cardTheme: const CardTheme(
    color: Colors.white,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
  ),
);

final ThemeData darkTheme = ThemeData.dark();

const TextStyle textTitleStyle = TextStyle(fontWeight: FontWeight.bold);

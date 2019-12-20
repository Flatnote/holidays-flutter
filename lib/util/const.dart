import 'package:flutter/material.dart';

class Constants {
  static String appName = "Holidays";

  //Colors for theme
  static Color themeColor = Colors.limeAccent[400];
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Colors.blue;
  static Color darkAccent = Colors.blueAccent;
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color badgeColor = Colors.red;
  static Color greyColor = Color(0xffaeaeae);
  static Color greyColor2 = Color(0xffE8E8E8);

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        title: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        title: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );

  static ThemeData test = ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Color(0xFFC4C4C4), fontSize: 20.0),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF3C4858), width: 2.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black45, width: 2.0),
        ),
      ),
      primaryColor: Color(0xFF3C4858),
      primaryIconTheme: IconThemeData(color: Color(0xFF3C4858)),
      textTheme: TextTheme(
        title: TextStyle(color: Color(0xFF414A53)),
        subhead: TextStyle(color: Color(0xFF686B6F)),
      ));
}

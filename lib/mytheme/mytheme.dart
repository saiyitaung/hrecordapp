import 'package:flutter/material.dart';

class MyTheme with ChangeNotifier {
  bool isDarkTheme;
  MyTheme(this.isDarkTheme);

  ThemeMode get currentTheme => isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.teal,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: Colors.grey[300],
      primaryColor: Colors.teal,
      accentColor: Colors.teal[300],
      textTheme: TextTheme(
          headline1: TextStyle(color: Colors.white),
          headline6: TextStyle(color: Colors.black)),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.grey[900],
      accentColor: Colors.grey[800],
      scaffoldBackgroundColor: Colors.grey[800],
      textTheme: TextTheme(
        headline1: TextStyle(color: Colors.white70),
        headline2: TextStyle(color: Colors.white70),
        headline3: TextStyle(color: Colors.white70),
        headline6: TextStyle(color: Colors.white70),
        bodyText1: TextStyle(color: Colors.white70),
        bodyText2: TextStyle(color: Colors.white70),
        subtitle1: TextStyle(color: Colors.white70),
        subtitle2: TextStyle(color: Colors.white70),
        caption: TextStyle(color: Colors.white38),
      ),
    );
  }
}

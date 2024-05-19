import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool isLightTheme = false;
  ThemeProvider(this.isLightTheme);

  toggleThemeData() {
    isLightTheme = !isLightTheme;

    notifyListeners();
  }

  ThemeData themeData() {
    return ThemeData(
      brightness: isLightTheme ? Brightness.light : Brightness.dark,
      primaryColor: isLightTheme ? Colors.blue : Colors.indigo,
      scaffoldBackgroundColor: isLightTheme ? Colors.white : Colors.black,
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        headline2: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        bodyText1: TextStyle(fontSize: 16),
        bodyText2: TextStyle(fontSize: 14),
      ).apply(
        bodyColor: isLightTheme ? Colors.black : Colors.white,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: isLightTheme ? Colors.blue : Colors.indigo,
        textTheme: ButtonTextTheme.primary,
      ),
      appBarTheme: AppBarTheme(
        color: isLightTheme ? Colors.blue : Colors.indigo,
      ),
      dividerColor: isLightTheme ? Colors.grey : Colors.white,
      cardColor: isLightTheme ? Colors.white : Colors.black,
      iconTheme: IconThemeData(
        color: isLightTheme ? Colors.black : Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: isLightTheme ? Colors.blue : Colors.indigo,
      ),
      // Add more theme properties as needed
    );
  }

}

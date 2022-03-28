
import 'package:flutter/material.dart';
import 'package:fooddrop2/constants.dart';

CustomTheme currentTheme = CustomTheme();



class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = true;
  ThemeMode get currentTheme=> _isDarkTheme ? ThemeMode.dark:ThemeMode.light;

  void toggleTheme(){
    _isDarkTheme =!_isDarkTheme;
    notifyListeners();
  }
  static ThemeData get lightTheme { //1
    return ThemeData( //2
        primaryColor: fPrimaryColor,
        scaffoldBackgroundColor: fBackgroundColor,
        fontFamily: 'NunitoSans', //3
        buttonTheme: ButtonThemeData( // 4
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: fButtonColor,
        )
    );
  }
  static ThemeData get darkTheme {
    return ThemeData(
        primaryColor: Colors.grey,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'NunitoSans',
        textTheme: ThemeData.dark().textTheme,
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: fButtonColor,
        )
    );
  }
}
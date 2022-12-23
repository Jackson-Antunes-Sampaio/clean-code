import 'package:flutter/material.dart';

ThemeData makeAppTheme (){

  const primaryColor = Color.fromRGBO(136, 14, 79, 1);
  const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
  const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);

  const secondaryColorDark = Color.fromRGBO(0, 37, 26, 1);

return ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    primarySwatch: generateMaterialColor(primaryColor),
    secondaryHeaderColor: secondaryColorDark,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: primaryColor),
    backgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: primaryColor,
      centerTitle: true
    ),
    textTheme: const  TextTheme(
        headline1: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: primaryColorDark,
        )
    ),
    inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColorLight)
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor)
        ),
        alignLabelWithHint: true
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),
          padding:  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        )
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),
          padding:  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        )
    ),
    buttonTheme:  ButtonThemeData(
        colorScheme: const ColorScheme.light(primary: primaryColor),
        buttonColor: primaryColor,
        splashColor: primaryColorLight,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        )
    )
);
}

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: color,
    100: color,
    200: color,
    300: color,
    400: color,
    500: color,
    600: color,
    700: color,
    800: color,
    900: color,
  });
}
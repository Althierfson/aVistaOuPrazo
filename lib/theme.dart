import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
    inputDecorationTheme:
        const InputDecorationTheme(outlineBorder: BorderSide.none),
    appBarTheme: const AppBarTheme(color: Color(0xFF0029FF)),
    elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Color(0xFF0029FF)))));

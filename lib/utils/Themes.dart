import 'package:flutter/material.dart';

ThemeData mainTheme = ThemeData(
        fontFamily: "Lato",
        colorScheme: const ColorScheme.light(
          primaryContainer: Color(0xFFD8E2FF),
          secondaryContainer: Color(0xFFF5F5F5),
          primary: Color(0xFF152573)
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xFF152573),
              ),
              borderRadius: BorderRadius.all(Radius.circular(5))
              
            ),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(color: Color(0xFF152573)),
          button: TextStyle(color: Color(0xFF152573)),
        ),
      );

TextStyle containerLabel = const TextStyle(
  fontFamily: "Lato",
  color: Color(0xFF152573),
  fontSize: 20.0
);
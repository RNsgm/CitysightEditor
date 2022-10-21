import 'package:citysight_editor/pages/Editor.dart';
import 'package:citysight_editor/pages/Home.dart';
import 'package:citysight_editor/pages/Login.dart';
import 'package:citysight_editor/utils/Themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy(); 
  runApp( App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
         GlobalMaterialLocalizations.delegate
       ],
       supportedLocales: [
         const Locale('ru')
       ],
      debugShowCheckedModeBanner: false,
      theme: mainTheme,
      title: "Citysight",
      // home: Home(),
      initialRoute: '/',
      routes: {
        '/':(context) => Home(),
        '/login': (context) => Login(),
        '/editor': (context) => Editor(),
      },
    );
  }
}
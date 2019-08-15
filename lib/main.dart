import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:Eyemoney/screens/adding.dart';
import 'package:Eyemoney/screens/home.dart';
import 'package:Eyemoney/screens/settings.dart';
import 'package:Eyemoney/screens/statistics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'outsourcing/globals.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English
        const Locale('de', ''), // German
        const Locale('ae', ''), // Arabia
        const Locale('zh', ''), // Chinese
        const Locale('es', ''), // Spain
        const Locale('fr', ''), // France
        const Locale('ru', ''), // Russia
      ],
      initialRoute: Home.routeName,
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        Home.routeName: (context) => Home(title: appName),
        // When navigating to the "/second" route, build the SecondScreen widget.
        Settings.routeName: (context) => Settings(),
        Adding.routeName: (context) => Adding(),
        Statistics.routeName: (context) => Statistics(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        // dark mode brightness: Brightness.dark,
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent,

        // Define the default font family.
        // fontFamily: 'Montserrat',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          title: TextStyle(fontSize: 18.0, color: Colors.black),
          body1: TextStyle(fontSize: 14.0, color: Colors.black),
          body2: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

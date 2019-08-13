import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:Eyemoney/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'outsourcing/globals.dart';

void main() {
  runApp(new MaterialApp(localizationsDelegates: [
    // ... app-specific localization delegate[s] here
    AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ], supportedLocales: [
    const Locale('en', ''), // English
    const Locale('de', ''),
    const Locale('ae', ''),
    const Locale('zh', ''),
    const Locale('es', ''),
    const Locale('fr', ''),
    const Locale('ru', ''),
  ], debugShowCheckedModeBanner: false, theme: ThemeData(fontFamily: 'Montserrat' /*, brightness: Brightness.dark*/), home: Home(title: appName)));
}

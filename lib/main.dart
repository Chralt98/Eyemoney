import 'package:flutter/material.dart';

import 'globals.dart';
import 'home.dart';

void main() {
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(fontFamily: 'Montserrat' /*, brightness: Brightness.dark*/),
      home: Home(title: appName, initialDate: DateTime.now())));
}

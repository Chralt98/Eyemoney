import 'package:Eyemoney/screens/home.dart';
import 'package:flutter/material.dart';

import 'outsourcing/globals.dart';

void main() {
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(fontFamily: 'Montserrat' /*, brightness: Brightness.dark*/),
      home: Home(title: appName, initialDate: DateTime.now())));
}

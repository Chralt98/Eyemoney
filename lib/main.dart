import 'package:flutter/material.dart';

import 'globals.dart';
import 'home.dart';

void main() {
  runApp(new MaterialApp(debugShowCheckedModeBanner: false, home: Home(title: appName, initialDate: DateTime.now())));
}

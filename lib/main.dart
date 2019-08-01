import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(new MaterialApp(debugShowCheckedModeBanner: false, home: Home(title: 'Cashprotocol', initialDate: DateTime.now())));
}

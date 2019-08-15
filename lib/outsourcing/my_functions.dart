library flutter_app.my_functions;

import 'dart:math';

import 'package:fluttertoast/fluttertoast.dart';

double round(double val, double places) {
  double mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}

String normTwoDecimal(String val) {
  String decimals = val.split('.')[1];
  if (decimals.length == 1) {
    val += '0';
  }
  return val;
}

void showToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIos: 1,
    fontSize: 14.0,
  );
}

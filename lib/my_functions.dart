library flutter_app.my_functions;

import 'dart:math';

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

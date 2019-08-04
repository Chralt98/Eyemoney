library flutter_app.globals;

import 'dart:math';

const String appName = 'Cashprotocol';
const String categoryPrefKey = 'category_pref';
List<String> standard_categories = ['foods', 'salary', 'rent', 'contract', 'household', 'clothing', 'education', 'electronics', 'donation', 'car', 'hairdresser'];
bool isRevenue = false;

double round(double val, double places) {
  double mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}

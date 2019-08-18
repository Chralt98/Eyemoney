library flutter_app.globals;

import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:flutter/material.dart';

const String appName = 'Eyemoney';
const String categoryPrefKey = 'category_pref';

List<String> getStandardCategories(BuildContext context) {
  return [
    AppLocalizations.of(context).foods,
    AppLocalizations.of(context).salary,
    AppLocalizations.of(context).rent,
    AppLocalizations.of(context).household,
    AppLocalizations.of(context).clothing,
    AppLocalizations.of(context).education,
    AppLocalizations.of(context).electronics,
    AppLocalizations.of(context).health,
    AppLocalizations.of(context).gift,
    AppLocalizations.of(context).car,
    AppLocalizations.of(context).haircut,
    AppLocalizations.of(context).contract,
  ];
}

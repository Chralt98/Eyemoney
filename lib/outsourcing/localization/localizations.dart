import 'dart:async';

import 'package:Eyemoney/outsourcing/l10n/messages_all.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get home {
    return Intl.message(
      'Home',
      name: 'home',
    );
  }

  String get statistics {
    return Intl.message(
      'Statistics',
      name: 'statistics',
    );
  }

  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
    );
  }

  String get amount {
    return Intl.message(
      'amount',
      name: 'amount',
    );
  }

  String get description {
    return Intl.message(
      'description',
      name: 'description',
    );
  }

  String get descriptionQuestion {
    return Intl.message(
      'What is it?',
      name: 'descriptionQuestion',
    );
  }

  String get expenditure {
    return Intl.message(
      'expenditure',
      name: 'expenditure',
    );
  }

  String get revenue {
    return Intl.message(
      'revenue',
      name: 'revenue',
    );
  }

  String get category {
    return Intl.message(
      'category',
      name: 'category',
    );
  }

  String get emptyCategory {
    return Intl.message(
      'other',
      name: 'emptyCategory',
    );
  }

  String get foods {
    return Intl.message(
      'foods',
      name: 'foods',
    );
  }

  String get salary {
    return Intl.message(
      'salary',
      name: 'salary',
    );
  }

  String get rent {
    return Intl.message(
      'rent',
      name: 'rent',
    );
  }

  String get household {
    return Intl.message(
      'household',
      name: 'household',
    );
  }

  String get clothing {
    return Intl.message(
      'clothing',
      name: 'clothing',
    );
  }

  String get education {
    return Intl.message(
      'education',
      name: 'education',
    );
  }

  String get electronics {
    return Intl.message(
      'electronics',
      name: 'electronics',
    );
  }

  String get gift {
    return Intl.message(
      'gift',
      name: 'gift',
    );
  }

  String get car {
    return Intl.message(
      'car',
      name: 'car',
    );
  }

  String get haircut {
    return Intl.message(
      'haircut',
      name: 'haircut',
    );
  }

  String get contract {
    return Intl.message(
      'contract',
      name: 'contract',
    );
  }

  String get addCategory {
    return Intl.message(
      'add category',
      name: 'addCategory',
    );
  }

  String get add {
    return Intl.message(
      'Add',
      name: 'add',
    );
  }

  String get addCategoryDescription {
    return Intl.message(
      'Which should be added?',
      name: 'addCategoryDescription',
    );
  }

  String get removed {
    return Intl.message(
      'removed',
      name: 'removed',
    );
  }

  String get undo {
    return Intl.message(
      'UNDO',
      name: 'undo',
    );
  }

  String get other {
    return Intl.message(
      'other',
      name: 'other',
    );
  }

  String get amountDescription {
    return Intl.message(
      'Please enter an amount',
      name: 'amountDescription',
    );
  }

  String get health {
    return Intl.message(
      'health',
      name: 'health',
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'de'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) {
    return false;
  }
}

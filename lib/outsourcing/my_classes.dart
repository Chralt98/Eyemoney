import 'package:Eyemoney/database/transaction.dart';
import 'package:flutter/material.dart';

class AddingArguments {
  final DateTime selectedDate;
  final MyTransaction myTransaction;

  AddingArguments({@required this.selectedDate, this.myTransaction});
}

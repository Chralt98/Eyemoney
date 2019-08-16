import 'package:Eyemoney/database/transaction.dart';
import 'package:flutter/material.dart';

class AddingArguments {
  final DateTime selectedDate;
  final MyTransaction myTransaction;
  final double balance;

  AddingArguments(
      {@required this.selectedDate,
      @required this.balance,
      this.myTransaction});
}

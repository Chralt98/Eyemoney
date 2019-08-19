import 'package:Eyemoney/database/transaction.dart';
import 'package:Eyemoney/outsourcing/my_functions.dart';
import 'package:flutter/material.dart';

class MoneySums extends StatelessWidget {
  final List<MyTransaction> transactions;

  MoneySums({@required this.transactions});

  @override
  Widget build(BuildContext context) {
    final _revenue = _getSum(context, _getTupleRevenueExpenditure()[0], Colors.lightGreen);
    final _expenditure = _getSum(context, _getTupleRevenueExpenditure()[1], Colors.red);
    final _balance = _getSum(context, _getTupleRevenueExpenditure()[0] + _getTupleRevenueExpenditure()[1], Theme.of(context).textTheme.body1.color);
    return Container(
      child: Row(
        children: <Widget>[
          _revenue,
          _expenditure,
          _balance,
        ],
      ),
    );
  }

  List<double> _getTupleRevenueExpenditure() {
    double sumRevenue = 0.0;
    double sumExpenditure = 0.0;
    if (transactions != null) {
      for (int i = 0; i < transactions.length; i++) {
        if (transactions[i].sign > 0) {
          sumRevenue += transactions[i].sign * transactions[i].amount * transactions[i].quantity;
        } else if (transactions[i].sign < 0) {
          sumExpenditure += transactions[i].sign * transactions[i].amount * transactions[i].quantity;
        }
      }
    }
    return [round(sumRevenue, 2), round(sumExpenditure, 2)];
  }

  Widget _getSum(BuildContext context, double amount, Color color) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final stringAmount = normTwoDecimal(round(amount, 2).toString());
    return Container(
      height: 26,
      width: screenWidth / 3,
      child: FittedBox(
        child: Text(stringAmount, textAlign: TextAlign.center, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        fit: BoxFit.scaleDown,
      ),
    );
  }
}

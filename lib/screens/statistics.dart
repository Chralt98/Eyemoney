import 'package:Eyemoney/custom_widgets/adding/sign_selector.dart';
import 'package:Eyemoney/database/transaction.dart';
import 'package:Eyemoney/outsourcing/my_functions.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class Statistics extends StatefulWidget {
  static const routeName = '/statistics';

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  List<MyTransaction> _myTransactions;
  Set<String> _categories;
  bool isRevenue = false;
  Map<String, double> dataMapRevenue = new Map();
  Map<String, double> dataMapExpenditure = new Map();

  List<Color> colorList = [
    Colors.redAccent,
    Colors.orangeAccent,
    Colors.lightBlue,
    Colors.greenAccent,
    Colors.amberAccent,
    Colors.lightGreen,
    Colors.yellow,
    Colors.cyanAccent,
    Colors.limeAccent,
    Colors.lime,
    Colors.lightBlueAccent,
    Colors.green,
    Colors.lightGreenAccent,
    Colors.tealAccent,
    Colors.cyan,
    Colors.deepOrangeAccent,
    Colors.blue
  ];

  @override
  void initState() {
    super.initState();
    dataMapExpenditure.putIfAbsent("no data", () => 0);
    dataMapRevenue.putIfAbsent("no data", () => 0);
    _loadDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SignSelector(
                mySwitch: _getSwitch(),
                onExpenditure: () {
                  setState(() {
                    isRevenue = false;
                  });
                },
                onRevenue: () {
                  setState(() {
                    isRevenue = true;
                  });
                },
              ),
              PieChart(
                dataMap: isRevenue ? dataMapRevenue : dataMapExpenditure,
                legendFontColor: Colors.blueGrey[900],
                legendFontSize: 14.0,
                legendFontWeight: FontWeight.w500,
                animationDuration: Duration(milliseconds: 800),
                chartLegendSpacing: 32.0,
                chartRadius: MediaQuery.of(context).size.width / 2.7,
                showChartValuesInPercentage: true,
                showChartValues: true,
                showChartValuesOutside: true,
                chartValuesColor: Colors.blueGrey[900].withOpacity(0.9),
                colorList: colorList,
                showLegends: true,
                decimalPlaces: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSwitch() {
    return Container(
      child: Transform.scale(
        scale: 2,
        child: Switch(
          value: isRevenue,
          onChanged: (bool value) => setState(
            () {
              isRevenue = value;
            },
          ),
          activeColor: Colors.lightGreen,
          inactiveThumbColor: Colors.red,
          inactiveTrackColor: Color.fromARGB(120, 255, 0, 0),
        ),
      ),
    );
  }

  void _loadDatabase() async {
    await getCategoriesWithPrices(DateTime.now()).then((list) {
      setState(() {
        _myTransactions = list;
      });
    }).whenComplete(() {
      dataMapRevenue.clear();
      dataMapExpenditure.clear();
      _myTransactions.forEach((transaction) {
        if (transaction.sign == -1) {
          dataMapExpenditure.putIfAbsent(normTwoDecimal(transaction.amount.toString()) + ", " + transaction.category, () => transaction.amount);
        } else if (transaction.sign == 1) {
          dataMapRevenue.putIfAbsent(normTwoDecimal(transaction.amount.toString()) + ", " + transaction.category, () => transaction.amount);
        }
      });
    });
  }
}

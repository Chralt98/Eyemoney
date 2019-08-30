import 'package:Eyemoney/custom_widgets/adding/sign_selector.dart';
import 'package:Eyemoney/custom_widgets/year_picker_dialog.dart';
import 'package:Eyemoney/database/transaction.dart';
import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:Eyemoney/outsourcing/my_functions.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:pie_chart/pie_chart.dart';

class Statistics extends StatefulWidget {
  static const routeName = '/statistics';

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  List<MyTransaction> _myTransactions;
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
    final List<String> _popUpMenuItems = List.of(['month', 'year', 'overall']);
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _choiceAction,
            itemBuilder: (BuildContext context) {
              return _popUpMenuItems.map((String choice) {
                return PopupMenuItem<String>(value: choice, child: Text(choice));
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
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
                legendFontSize: 10.0,
                legendFontWeight: FontWeight.normal,
                animationDuration: Duration(milliseconds: 800),
                chartLegendSpacing: 32.0,
                chartRadius: MediaQuery.of(context).size.width / 2.5,
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

  void _choiceAction(String choice) {
    if (choice == 'month') {
      showMonthPicker(context: context, initialDate: DateTime.now()).then(
        (date) => setState(
          () {
            _loadDatabase(date: date, time: 'm');
          },
        ),
      );
    } else if (choice == 'year') {
      showYearPicker(context: context, initialDate: DateTime.now()).then(
        (date) => setState(
          () {
            _loadDatabase(date: date, time: 'Y');
          },
        ),
      );
    } else if (choice == 'overall') {
      _loadDatabase();
    }
  }

  void _loadDatabase({DateTime date, String time}) async {
    await ((date == null || time == null) ? getCategoriesWithPricesOverall() : getCategoriesWithPrices(date, time)).then((list) {
      setState(() {
        _myTransactions = list;
      });
    }).whenComplete(() {
      dataMapExpenditure.clear();
      dataMapRevenue.clear();
      _myTransactions.forEach((transaction) {
        if (transaction.sign == -1) {
          dataMapExpenditure.putIfAbsent(
              transaction.category + "\n" + AppLocalizations.of(context).money + ': ' + normTwoDecimal(transaction.amount.toString()), () => transaction.amount);
        } else if (transaction.sign == 1) {
          dataMapRevenue.putIfAbsent(
              transaction.category + "\n" + AppLocalizations.of(context).money + ': ' + normTwoDecimal(transaction.amount.toString()), () => transaction.amount);
        }
      });
      if (dataMapRevenue.isEmpty) dataMapRevenue.putIfAbsent("no data", () => 0);
      if (dataMapExpenditure.isEmpty) dataMapExpenditure.putIfAbsent("no data", () => 0);
    });
  }
}

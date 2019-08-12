import 'package:Eyemoney/outsourcing/globals.dart';
import 'package:Eyemoney/outsourcing/localization/localizations.dart';
import 'package:Eyemoney/screens/settings.dart';
import 'package:Eyemoney/screens/statistics.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text(appName, textScaleFactor: 2, style: TextStyle(color: Colors.white)),
                Icon(
                  Icons.fiber_smart_record,
                  size: 50,
                  color: Colors.white,
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).home),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).statistics),
            leading: Icon(Icons.assessment),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => Statistics()),
              );
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).settings),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => Settings()),
              );
            },
          ),
        ],
      ),
    );
  }
}

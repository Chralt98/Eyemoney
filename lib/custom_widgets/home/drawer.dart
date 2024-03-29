import 'package:Eyemoney/outsourcing/global_vars.dart';
import 'package:Eyemoney/outsourcing/localization/localizations.dart';
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
                Text(appName,
                    textScaleFactor: 2, style: TextStyle(color: Colors.white)),
                Image(
                  image: AssetImage('assets/images/inner_favicon.png'),
                  height: 50,
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context).home,
              style: Theme.of(context).textTheme.body2,
            ),
            leading: Icon(
              Icons.home,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context).statistics,
              style: Theme.of(context).textTheme.body2,
            ),
            leading: Icon(
              Icons.assessment,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/statistics');
            },
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context).settings,
              style: Theme.of(context).textTheme.body2,
            ),
            leading: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}

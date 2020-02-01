import 'package:flutter/material.dart';
import 'package:lost_and_found_app/routes/Routes.dart';

class CustomDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Lost and Found"),
            accountEmail: Text("Find what you lost"),
            currentAccountPicture: CircleAvatar(
              backgroundColor:
              Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: Text(
                "L",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            title: Text("Lost Items"),
            leading: Icon(Icons.shopping_cart),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, Routes.items);
            },
          ),
          ListTile(
            title: Text("Post Item"),
            leading: Icon(Icons.add_to_queue),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, Routes.postItem);
            },
          ),
        ],
      ),
    );
  }

}
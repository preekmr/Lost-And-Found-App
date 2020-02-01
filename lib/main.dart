import 'package:flutter/material.dart';
import 'package:lost_and_found_app/screens/items.dart';
import "package:lost_and_found_app/screens/login.dart";
import 'package:lost_and_found_app/routes/Routes.dart';
import 'package:lost_and_found_app/screens/post.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    static const BASE_URL="http://localhost:5000/";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lost & Found",
      theme: ThemeData(primaryColor: Colors.black, accentColor: Colors.black),
      home: LoginPage(title: "Login"),
      routes:  {
        Routes.login: (context) => LoginPage(title: "Login"),
        Routes.items: (context) => ItemsPage(title: "Lost Items"),
        Routes.postItem: (context) => PostItemPage(title: "Post a Lost Item")
      },
      debugShowCheckedModeBanner: false);
  }
}

import 'package:commons/screens/home/home_page.dart';
import 'package:commons/screens/login/login_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

final routes = {
  '/login': (BuildContext context) => new LoginPage(),
  '/home': (BuildContext context) => new HomePage(),
  '/': (BuildContext context) => new HomePage(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Commons App',
      theme: new ThemeData(primarySwatch: Colors.blue),
      routes: routes,
    );
  }
}
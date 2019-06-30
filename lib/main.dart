import 'dart:async';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:commons/helper/localizations.dart';
import 'package:commons/plugins/receive_sharing_intent.dart';
import 'package:commons/screens/home/home_page.dart';
import 'package:commons/screens/login/login_page.dart';
import 'package:commons/utils/misc_util.dart';
import 'package:flutter/material.dart';


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription _intentDataStreamSubscription;
  List<String> _sharedFiles;

  var homePage=new HomePage();
  var loginPage=new LoginPage();

  @override
  void initState() {
    super.initState();

    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getImageStream().listen((List<String> value) {
          print("receiving sharing intent");
          print(value);
            _sharedFiles = value;
            homePage.setSharedFile(_sharedFiles);
        }, onError: (err) {
          print("getIntentDataStream error: $err");
        });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialImage().then((List<String> value) {
      print("receiving sharing intent");
      print(value);
      _sharedFiles = value;
      homePage.setSharedFile(_sharedFiles);
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [Locale("en"), Locale("es")],
      title: "Commons",
      theme: new ThemeData(primaryColor: hexToColor("#0c609c"),
          primaryColorDark: hexToColor("#00376d")),
      routes: {
        '/login': (BuildContext context) => loginPage,
        '/home': (BuildContext context) => homePage,
        '/': (BuildContext context) => homePage,
      },
      home: homePage,
    );
  }
}
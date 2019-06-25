import 'dart:async';
import 'dart:io';

import 'package:commons/model/UploadableFile.dart';
import 'package:commons/plugins/receive_sharing_intent.dart';
import 'package:commons/screens/home/home_page.dart';
import 'package:commons/screens/login/login_page.dart';
import 'package:commons/screens/upload/description_page.dart';
import 'package:commons/utils/misc_util.dart';
import 'package:flutter/material.dart';

import 'app_config.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription _intentDataStreamSubscription;
  List<String> _sharedFiles;

  @override
  void initState() {
    super.initState();

    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getImageStream().listen((List<String> value) {
          print(value);
          _sharedFiles = value;
        }, onError: (err) {
          print("getIntentDataStream error: $err");
        });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialImage().then((List<String> value) {
      print(value);
      _sharedFiles = value;
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var config = AppConfig.of(context);

    print(_sharedFiles);

    return new MaterialApp(
      title: config.appName,
      theme: new ThemeData(primaryColor: hexToColor("#0c609c"),
          primaryColorDark: hexToColor("#00376d")),
      routes: {
        '/login': (BuildContext context) => new LoginPage(),
        '/home': (BuildContext context) => new HomePage(sharedFiles: _sharedFiles),
        '/': (BuildContext context) => new HomePage(sharedFiles: _sharedFiles),
      },
    );
  }
}
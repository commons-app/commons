import 'dart:io';

import 'package:flutter/material.dart';

import 'app_config.dart';
import 'helper/localizations.dart';
import 'main.dart';

Future main() async {
  var configuredApp = new AppConfig(
    appName: 'Commons',
    flavorName: 'prod',
    commonsBaseUrl: 'https://commons.wikimedia.org/w/api.php',
    signUpUrl: 'https://commons.m.wikimedia.org/w/index.php?title=Special:CreateAccount&returnto=Main+Page&returntoquery=welcome%3Dyes',
    child: new MyApp(),
  );

  final Locale myLocale = Locale(Platform.localeName);
  await AppLocalizations.load(myLocale);
  runApp(configuredApp);
}
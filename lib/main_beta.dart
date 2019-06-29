import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stetho/flutter_stetho.dart';

import 'app_config.dart';
import 'helper/localizations.dart';
import 'main.dart';

void main() async {
  var configuredApp = new AppConfig(
    appName: 'Commons Beta',
    flavorName: 'beta',
    commonsBaseUrl: 'https://commons.wikimedia.beta.wmflabs.org/w/api.php',
    signUpUrl: 'https://commons.m.wikimedia.beta.wmflabs.org/w/index.php?title=Special:CreateAccount&returnto=Main+Page&returntoquery=welcome%3Dyes',
    child: new MyApp(),
  );

  Stetho.initialize();

  final Locale myLocale = Locale(Platform.localeName);
  await AppLocalizations.load(myLocale);

  runApp(configuredApp);
}
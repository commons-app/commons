import 'app_config.dart';
import 'main.dart';
import 'package:flutter/material.dart';

void main() {
  var configuredApp = new AppConfig(
    appName: 'Commons',
    flavorName: 'prod',
    commonsBaseUrl: 'https://commons.wikimedia.org/w/api.php',
    signUpUrl: 'https://commons.m.wikimedia.org/w/index.php?title=Special:CreateAccount&returnto=Main+Page&returntoquery=welcome%3Dyes',
    child: new MyApp(),
  );

  runApp(configuredApp);
}
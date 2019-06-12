import 'app_config.dart';
import 'main.dart';
import 'package:flutter/material.dart';

void main() {
  var configuredApp = new AppConfig(
    appName: 'Commons Beta',
    flavorName: 'beta',
    commonsBaseUrl: 'https://commons.wikimedia.org/w/api.php',
    child: new MyApp(),
  );

  runApp(configuredApp);
}
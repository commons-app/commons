import 'app_config.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stetho/flutter_stetho.dart';

void main() {
  var configuredApp = new AppConfig(
    appName: 'Commons Beta',
    flavorName: 'beta',
    commonsBaseUrl: 'https://commons.wikimedia.beta.wmflabs.org/w/api.php',
    child: new MyApp(),
  );

  Stetho.initialize();
  runApp(configuredApp);
}
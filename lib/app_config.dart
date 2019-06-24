import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class AppConfig extends InheritedWidget {
  AppConfig({
    @required this.appName,
    @required this.flavorName,
    @required this.commonsBaseUrl,
    @required this.signUpUrl,
    @required Widget child,
  }) : super(child: child);

  final String appName;
  final String flavorName;
  final String commonsBaseUrl;
  final String signUpUrl;

  static AppConfig of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppConfig);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
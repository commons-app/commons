import 'package:commons/model/response/media/contributions.dart';
import 'package:commons/screens/home/media_detail/media_detail.dart';
import 'package:flutter/material.dart';

goToMediaDetails(BuildContext context, AllImages contribution) {
  openWidgetWithFade(context, MediaDetailScreen(contribution));
}

openWidgetWithFade(BuildContext context, Widget widget) {
  Navigator.of(context).push(
    PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return widget;
        }),
  );
}

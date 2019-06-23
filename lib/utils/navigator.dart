import 'package:commons/model/Media.dart';
import 'package:commons/screens/home/media_detail/media_detail.dart';
import 'package:flutter/material.dart';

goToMediaDetails(BuildContext context, Media media) {
  openWidgetWithFade(context, MediaDetailScreen(media));
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

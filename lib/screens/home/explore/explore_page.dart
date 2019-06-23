import 'package:commons/app_config.dart';
import 'package:commons/model/Media.dart';
import 'package:commons/model/response/MwQueryPage.dart';
import 'package:commons/screens/home/contributions/contributions_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

import 'explore_presenter.dart';

class ExplorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ExploreState();
  }
}

class _ExploreState extends State<ExplorePage> implements ExploreContract {
  List<MwQueryPage> contributions = List();
  ExplorePresenter presenter;

  bool _isPresenterInit = false;

  @override
  Widget build(BuildContext context) {
    if (!_isPresenterInit) {
      _isPresenterInit = true;
      var config = AppConfig.of(this.context);
      presenter = new ExplorePresenter(config.commonsBaseUrl, this);
    }

    return Scaffold(
        body: PagewiseListView(
            pageSize: 10,
            padding: EdgeInsets.all(5.0),
            itemBuilder: (context, entry, index) => listItem(entry),
            pageFuture: (pageIndex) => presenter.getFeaturedImages()
        ));
  }

  MediaItem listItem(Media media) {
    return MediaItem(media);
  }
}

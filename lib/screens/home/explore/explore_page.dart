import 'package:commons/app_config.dart';
import 'package:commons/model/Media.dart';
import 'package:commons/model/response/MwQueryPage.dart';
import 'package:commons/screens/home/contributions/contributions_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

import 'explore_presenter.dart';

class ExplorePage extends StatefulWidget {
  final featuredImages = "Featured_pictures_on_Wikimedia_Commons";

  final String category;
  final bool showAppbar;

  ExplorePage({Key key, this.showAppbar, this.category});

  @override
  State<StatefulWidget> createState() {
    return new _ExploreState(
        this.showAppbar ==null? false: this.showAppbar, category == null ? featuredImages : category);
  }
}

class _ExploreState extends State<ExplorePage> implements ExploreContract {
  List<MwQueryPage> contributions = List();
  ExplorePresenter presenter;

  bool _isPresenterInit = false;
  String _category;
  bool _showAppbar;

  _ExploreState(bool showAppBar, String category) {
    _showAppbar = showAppBar;
    _category = category;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPresenterInit) {
      _isPresenterInit = true;
      var config = AppConfig.of(this.context);
      presenter = new ExplorePresenter(config.commonsBaseUrl, this);
    }

    var homeAppBar = AppBar(
        title: new Text("$_category")
    );

    return Scaffold(
        appBar: _showAppbar ? homeAppBar : null,
        body: getMediaList());
  }

  PagewiseListView<Media> getMediaList() {
    return PagewiseListView(
        pageSize: 10,
        padding: EdgeInsets.all(5.0),
        itemBuilder: (context, entry, index) => listItem(entry),
        pageFuture: (pageIndex) =>
            presenter.getCategoryImages(_category)
    );
  }

  MediaItem listItem(Media media) {
    return MediaItem(media);
  }
}

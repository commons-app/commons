import 'package:commons/app_config.dart';
import 'package:commons/model/response/MwQueryPage.dart';
import 'package:commons/screens/home/contributions/contributions_item.dart';
import 'package:flutter/material.dart';

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
      var featuredImages = presenter.getFeaturedImages();
      featuredImages.then((List<MwQueryPage> onValue) {
        setState(() {
          contributions = onValue;
        });
      });
    }

    return Scaffold(
        body: contributions.length == 0
            ? new Center(
                child: const Center(child: const CircularProgressIndicator()),
              )
            : ListView.builder(
                padding: EdgeInsets.all(5.0),
                itemCount: contributions.length,
                itemBuilder: (context, index) =>
                    listItem(contributions.elementAt(index))));
  }

  ContributionsItem listItem(MwQueryPage mQueryPage) {
    return ContributionsItem(mQueryPage.toAllImage());
  }
}

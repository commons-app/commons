import 'package:commons/app_config.dart';
import 'package:commons/model/response/media/contributions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

import 'contributions_item.dart';
import 'contributions_presenter.dart';


class ContributionsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ContributionsState();
  }
}

class _ContributionsState extends State<ContributionsPage>
    implements ContributionsContract {

  List<AllImages> contributions = List();
  ContributionsPresenter presenter;

  bool _isPresenterInit = false;

  @override
  Widget build(BuildContext context) {
    if (!_isPresenterInit) {
      _isPresenterInit = true;
      var config = AppConfig.of(this.context);
      presenter = new ContributionsPresenter(config.commonsBaseUrl, this);
    }
    
    return Scaffold(
        body: PagewiseListView(
            pageSize: 10,
            padding: EdgeInsets.all(5.0),
            itemBuilder: (context, entry, index) => listItem(entry),
            pageFuture: (pageIndex) => presenter.getContributions()
        ));
  }

  ContributionsItem listItem(AllImages allimage) {
    return ContributionsItem(allimage);
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:commons/app_config.dart';
import 'package:commons/model/response/media/contributions.dart';
import 'package:flutter/material.dart';

import 'contributions_presenter.dart';

class ContributionsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ContributionsState();
  }
}

class _ContributionsState extends State<ContributionsPage>
    implements ContributionsContract {
  List<Contribution> contributions = [];
  ContributionsPresenter presenter;

  @override
  Widget build(BuildContext context) {
    var config = AppConfig.of(this.context);
    presenter = new ContributionsPresenter(config.commonsBaseUrl, this);
    presenter.getContributions().then((response) {
      setState(() {
        contributions = response;
      });
    });

    return Scaffold(
        body: ListView.builder(
            itemCount: contributions.length,
            itemBuilder: (context, int) {
              return Stack(alignment: Alignment.bottomLeft, children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 200,
                ),
                new Card(
                    child: new CachedNetworkImage(
                        imageUrl: contributions.elementAt(int).url)),
                new Container(
                    margin: const EdgeInsets.only(left: 10.0,bottom: 10),
                    child: Text(contributions.elementAt(int).title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
              ]);
            }));
  }
}

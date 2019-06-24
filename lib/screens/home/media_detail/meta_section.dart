import 'package:commons/model/Media.dart';
import 'package:commons/screens/home/explore/explore_page.dart';
import 'package:commons/utils/misc_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class MetaSection extends StatelessWidget {
  final Media media;

  MetaSection(this.media);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.all(10.0),
          color: hexToColor("#0c609c"),
          child: getTitleSection("Title: ${media.name}"),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          height: 10.0,
        ),
        new GestureDetector(
            onTap: () => openLinkInWebBrowser(media.licenseUrl),
            child: _getSectionOrContainer(
                'License', media.licenseName,
                isLink: true)),
        _getSectionOrContainer(
            'Description', media.description),
        _getSectionOrContainer(
            'Coordinates',
            "${media.latLng.latitude},${media.latLng.longitude}".contains(
                "null")
                ? "NA"
                : "${media.latLng.latitude},${media.latLng.longitude}"),
        new Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Html(
                    data: "Categories",
                    defaultTextStyle: TextStyle(
                        color: hexToColor("#0c609c"),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(flex: 6,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: new Padding(
                                padding: const EdgeInsets.only(top:4.0,bottom: 4.0),
                                child: Text(
                                    media.categories[index].categoryName)),
                            onTap: () => onCategoryTapped(context, media.categories[index].categoryName),
                          );
                        }, itemCount: media.categories.length))
              ],
            )),
        _getSectionOrContainer(
            'Uploaded Date', media.uploadDateTime.toIso8601String())
        //TODO, format date time,
      ],
    );
  }

  Widget _getSectionOrContainer(String title, String content,
      {dynamic formatterFunction, bool isLink: false}) {
    return content == null
        ? Container()
        : _getMetaInfoSection(title,
            (formatterFunction != null ? formatterFunction(content) : content),
            isLink: isLink);
  }

  Widget _getMetaInfoSection(String title, String content,
      {bool isLink: false}) {
    if (content == null) return Container();

    var contentSection = Expanded(
      flex: 6,
      child: GestureDetector(
        child: Html(
          data: content,
          defaultTextStyle: TextStyle(
              color: isLink ? Colors.blue : Colors.black, fontSize: 16.0),
        ),
      ),
    );

    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Html(
                data :title,
                defaultTextStyle: TextStyle(
                    color: hexToColor("#0c609c"),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            contentSection
          ],
        ));
  }

  getTitleSection(String title) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Html(
                data: '$title',
                defaultTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ));
  }

  onCategoryTapped(BuildContext context, String categoryName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ExplorePage(
                showAppbar: true,
                  category: categoryName),
        ));
  }



  /*Widget _getDescriptionsSection(String title, String content,
      {bool isLink: false}) {
    if (content == null) return Container();

    var contentSection = Expanded(
      flex: 6,
      child: GestureDetector(
        child: Html(
          data: content,
          defaultTextStyle: TextStyle(
              color: isLink ? Colors.blue : Colors.black, fontSize: 16.0),
        ),
      ),
    );

    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Html(
                data :title,
                defaultTextStyle: TextStyle(
                    color: hexToColor("#0c609c"),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),

      Expanded(flex: 7,
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: new Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                          media.categories[index].categoryName)),
                  onTap: () => onCategoryTapped(context, media.categories[index].categoryName),
                );
              }, itemCount: media.categories.length))
            contentSection
          ],
        ));
  }*/
}

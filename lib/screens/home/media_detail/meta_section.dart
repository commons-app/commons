import 'package:commons/model/response/media/contributions.dart';
import 'package:commons/utils/misc_util.dart';
import 'package:flutter/material.dart';

class MetaSection extends StatelessWidget {
  final AllImages media;

  MetaSection(this.media);

  @override
  Widget build(BuildContext context) {
    var latitude = null!=media.extmetadata.gPSLatitude?media.extmetadata.gPSLatitude.value:null;
    var longitude = null!=media.extmetadata.gPSLongitude?media.extmetadata.gPSLongitude.value:null;
    var name = media.name;
    var licenseUrl = media.extmetadata.licenseUrl.value.toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.all(10.0),
          color: hexToColor("#0c609c"),
          child: getTitleSection("Title: $name"),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          height: 10.0,
        ),
        new GestureDetector(
            onTap: () => openLinkInWebBrowser(licenseUrl),
            child: _getSectionOrContainer(
                'License', media.extmetadata.licenseShortName.value,
                isLink: true)),
        _getSectionOrContainer(
            'Description', media.extmetadata.imageDescription.value),
        _getSectionOrContainer(
            'Coordinates',
            "$latitude,$longitude".contains("null")
                ? "NA"
                : "$latitude,$longitude"),
        _getSectionOrContainer(
            'Categories',
            getCategoryDisplayableString(
                media.extmetadata.categories.toJson())),
        _getSectionOrContainer('Uploaded Date',
            formatDate(media.extmetadata.dateTime.value).toString())
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
        child: Text(
          content,
          style: TextStyle(
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
              child: Text(
                '$title:',
                style: TextStyle(
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
              child: Text(
                '$title',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ));
  }
}

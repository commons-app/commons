import 'package:commons/model/response/media/contributions.dart';
import 'package:flutter/material.dart';

class MetaSection extends StatelessWidget {
  final AllImages media;

  MetaSection(this.media);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
      Text(
      "Media Details",
    ),
    Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      height: 8.0,
    ),
    _getSectionOrContainer('Title', media.title),
    _getSectionOrContainer('Description', media.descriptionurl),
    ],
    );
  }

  Widget _getSectionOrContainer(String title, String content,
      {dynamic formatterFunction, bool isLink: false}) {
    return content == null
        ? Container()
        : _getMetaInfoSection(
        title,
        (formatterFunction != null
            ? formatterFunction(content)
            : content),
        isLink: isLink);
  }

  Widget _getMetaInfoSection(String title, String content,
      {bool isLink: false}) {
    if (content == null) return Container();

    var contentSection = Expanded(
      flex: 10,
      child: GestureDetector(
        child: Text(
          content,
          style: TextStyle(
              color: isLink ? Colors.blue : Colors.black, fontSize: 16.0),
        ),
      ),
    );

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 10,
              child: Text(
                '$title:',
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
            ),
            contentSection
          ],
        ));
  }
}

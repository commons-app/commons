import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:commons/model/response/media/contributions.dart';
import 'package:flutter/material.dart';

import 'meta_section.dart';

class MediaDetailScreen extends StatefulWidget {
  final AllImages _mediaItem;

  MediaDetailScreen(this._mediaItem);

  @override
  MediaDetailScreenState createState() {
    return MediaDetailScreenState();
  }
}

class MediaDetailScreenState extends State<MediaDetailScreen> {
  dynamic _mediaDetails;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 100), () => setState(() => _visible = true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(widget._mediaItem),
        body: SingleChildScrollView(
            child: Column(children: [
          new Hero(
            tag: "Image-Tag-${widget._mediaItem.hashCode}",
            child: CachedNetworkImage(
                fit: BoxFit.cover,
                width: double.infinity,
                imageUrl: widget._mediaItem.url),
          ),
          new Container(
            height: 10,
          ),
          new Card(
              child: new MetaSection(widget._mediaItem)),
          new Container(
            height: 20,
          ),
        ])));
  }

  Widget _buildAppBar(AllImages media) {
    return AppBar(title: Text(media.title));
  }

  /*Widget _buildMetaSection(MediaItem mediaItem) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                TextBubble(
                  mediaItem.getReleaseYear().toString(),
                  backgroundColor: Color(0xffF47663),
                ),
                Container(
                  width: 8.0,
                ),
                TextBubble(mediaItem.voteAverage.toString(),
                    backgroundColor: Color(0xffF47663)),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(mediaItem.title,
                  style: TextStyle(color: Color(0xFFEEEEEE), fontSize: 20.0)),
            ),
            Row(
              children: getGenresForIds(mediaItem.genreIds)
                  .sublist(0, min(5, mediaItem.genreIds.length))
                  .map((genre) => Row(
                        children: <Widget>[
                          TextBubble(genre),
                          Container(
                            width: 8.0,
                          )
                        ],
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }*/

  Widget _buildContentSection(AllImages media) {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        Container(
          decoration: BoxDecoration(color: const Color(0xff222128)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "SYNOPSIS",
                  style: const TextStyle(color: Colors.white),
                ),
                Container(
                  height: 8.0,
                ),
                Text(media.name,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 12.0)),
                Container(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

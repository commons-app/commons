import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:commons/model/Media.dart';
import 'package:flutter/material.dart';

import 'meta_section.dart';

class MediaDetailScreen extends StatefulWidget {
  final Media _mediaItem;

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
              child: new MetaSection(widget._mediaItem)),
          new Container(
            height: 20,
          ),
        ])));
  }

  Widget _buildAppBar(Media media) {
    return AppBar(title: Text(media.prettyName()));
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:commons/model/Media.dart';
import 'package:commons/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class MediaItem extends StatelessWidget {
  MediaItem(this.media);

  final Media media;

  Widget _getTitleSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Html(
                    data: media.prettyName(),
                    defaultTextStyle: Theme.of(context)
                        .textTheme
                        .subhead
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 12.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => goToMediaDetails(context, media),
        child: Column(
          children: <Widget>[
            Hero(
              child: CachedNetworkImage(
                imageUrl: media.thumbUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300.0,
                placeholder: (context, url) => new Icon(Icons.image),
              ),
              tag: "Image-Tag-${media.name.hashCode}",
            ),
            _getTitleSection(context),
          ],
        ),
      ),
    );
  }
}

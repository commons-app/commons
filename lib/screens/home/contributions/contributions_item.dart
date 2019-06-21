import 'package:cached_network_image/cached_network_image.dart';
import 'package:commons/model/response/media/contributions.dart';
import 'package:commons/utils/navigator.dart';
import 'package:flutter/material.dart';

class ContributionsItem extends StatelessWidget {
  ContributionsItem(this.contribution);

  final AllImages contribution;

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
                  child: Text(
                    contribution.name,
                    style: Theme.of(context)
                        .textTheme
                        .title
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
        onTap: () => goToMediaDetails(context, contribution),
        child: Column(
          children: <Widget>[
            Hero(
              child: CachedNetworkImage(
                imageUrl: contribution.url,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300.0,
                fadeInDuration: Duration(milliseconds: 50),
              ),
              tag: "Image-Tag-${contribution.hashCode}",
            ),
            _getTitleSection(context),
          ],
        ),
      ),
    );
  }
}

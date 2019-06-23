import 'package:commons/bloc/CommonsBloc.dart';
import 'package:commons/model/Media.dart';
import 'package:commons/model/response/MwQueryPage.dart';
import 'package:commons/model/response/MwQueryResponse.dart';

abstract class ExploreContract {}

class ExplorePresenter {
  ExploreContract _view;
  CommonsBloc commonsBloc;
  Map<String, String> continuation;

  ExplorePresenter(String baseEndpoint, this._view) {
    commonsBloc = new CommonsBloc(baseEndpoint);
  }

  Future<List<Media>> getFeaturedImages() async {
    return commonsBloc.getFeaturedImages("Featured_pictures_on_Wikimedia_Commons", continuation).then((
        MwQueryResponse value) {
      continuation = value.continuation;
      List<Media> mediaList = new List();
      value.query.pages.forEach((MwQueryPage page) {
        mediaList.add(Media.fromPage(page));
      });
      return mediaList;
    }, onError: (e) {
      throw e;
    });
  }
}

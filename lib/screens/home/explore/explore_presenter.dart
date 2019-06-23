import 'package:commons/bloc/CommonsBloc.dart';
import 'package:commons/model/response/MwQueryPage.dart';
import 'package:commons/model/response/MwQueryResponse.dart';
import 'package:commons/model/response/media/contributions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ExploreContract {}

class ExplorePresenter {
  ExploreContract _view;
  CommonsBloc commonsBloc;
  Map<String, String> continuation;

  ExplorePresenter(String baseEndpoint, this._view) {
    commonsBloc = new CommonsBloc(baseEndpoint);
  }

  Future<List<MwQueryPage>> getFeaturedImages() async {
    return commonsBloc.getFeaturedImages("Featured_pictures_on_Wikimedia_Commons", continuation).then((
        MwQueryResponse value) {
      continuation = value.continuation;
      return value.query.pages;
    }, onError: (e) {
      throw e;
    });
  }
}

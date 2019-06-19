import 'package:commons/bloc/CommonsBloc.dart';
import 'package:commons/model/response/media/contributions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ContributionsContract {}

class ContributionsPresenter {
  ContributionsContract _view;
  CommonsBloc commonsBloc;

  ContributionsPresenter(String baseEndpoint, this._view) {
    commonsBloc = new CommonsBloc(baseEndpoint);
  }

  Future<List<Contribution>> getContributions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return commonsBloc.fetchContributions(prefs.getString('username'));
  }
}

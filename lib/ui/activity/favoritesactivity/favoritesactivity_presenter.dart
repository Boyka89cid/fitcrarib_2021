import 'package:fitcarib/base/presenter/base_presenter.dart';
import 'package:flutter/services.dart';

abstract class FavoritesActivityContract extends BaseContract {
  void toWelcome();
}

class FavoritesActivityPresenter extends BasePresenter {
  FavoritesActivityPresenter(BaseContract view) : super(view);

  void toWelcomeScreen()
  {
    (view as FavoritesActivityContract).toWelcome();
  }


}
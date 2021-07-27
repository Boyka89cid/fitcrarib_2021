import 'package:fitcarib/base/presenter/base_presenter.dart';
import 'package:flutter/services.dart';

abstract class ActivityContract extends BaseContract {
  void toWelcome();
}

class ActivityPresenter extends BasePresenter {
  ActivityPresenter(BaseContract view) : super(view);

  void toWelcomeScreen()
  {
    (view as ActivityContract).toWelcome();
  }


}
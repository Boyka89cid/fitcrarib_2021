import 'package:flutter/material.dart';
import 'package:fitcarib/base/ui/base_screen.dart';
import 'package:fitcarib/ui/login/login_presenter.dart';

class LoginScreen extends BaseScreen {
  LoginScreen(String title, listener) : super(title, listener);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseScreenState<LoginScreen, LoginPresenter> implements LoginContract{
  @override
  Widget buildBody(BuildContext context) {
    return Container();
  }

  @override
  LoginPresenter createPresenter() {
    return LoginPresenter(this);
  }
}
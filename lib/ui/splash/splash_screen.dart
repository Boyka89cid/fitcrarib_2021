import 'package:fitcarib/ui/myactivity/activity.dart';
import 'package:fitcarib/ui/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:fitcarib/base/ui/base_screen.dart';
import 'package:fitcarib/ui/splash/splash_presenter.dart';
import 'package:flutter/services.dart';

class SplashScreen extends BaseScreen
{
  SplashScreen(String title, listener) : super(title, listener);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseScreenState<SplashScreen, SplashPresenter> implements SplashContract
{
  @override
  Widget buildBody(BuildContext context)
  {
    return Container(
      decoration: const BoxDecoration(
        image: const DecorationImage(
          fit: BoxFit.fill,
          image: const AssetImage("assets/images/splash.png"),
        ),
      ),
    );
  }

  @override
  SplashPresenter createPresenter() {return SplashPresenter(this);}

  @override
  void initState()
  {
    presenter!.timer();
    presenter!.hideStatusBar();
  }

  @override
  void toWelcomeScreen()
  {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WelcomeScreen()));
    //widget.listener.getRouter().navigateTo(context, '/welcome',clearStack: true);
  }

  @override
  void toActivityScreen()
  {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ActivityScreen()));
    //widget.listener.getRouter().navigateTo(context, '/activity',clearStack: true);
  }
}

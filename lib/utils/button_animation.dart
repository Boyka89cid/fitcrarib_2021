import 'package:flutter/material.dart';

class AnimatedAppButton extends StatelessWidget {
  final String? title;
  final onTap;
  final Color? color;
  final Color? textColor;
  final Color? loadingColor;
  final String? tag;
  AnimatedAppButton(
      {Key? key,
      required this.buttonController,
      this.title,
      this.onTap,
      this.color = Colors.white,
      this.textColor = Colors.blue,
      this.loadingColor = Colors.blue,
      this.tag})
      : buttonSqueezeanimation = new Tween(
          begin: 180.0,
          end: 40.0,
        ).animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.0,
              0.200,
            ),
          ),
        ),
        super(key: key);

  final AnimationController buttonController;
  final Animation buttonSqueezeanimation;

  void showLoading() {
    buttonController.forward();
  }

  void hideLoading() {
    buttonController.reverse();
  }

  Widget _buildAnimation(BuildContext context, Widget? child)
  {
    return new Padding(
      padding: const EdgeInsets.all(1.0),
      child: new InkWell(
          onTap: () {},
          child: Container(
              width: buttonSqueezeanimation.value,
              height: 40.0,
              margin: const EdgeInsets.all(2.0),
              alignment: FractionalOffset.center,
              child: buttonSqueezeanimation.value > 75.0
                  ? Material(
                      color: color,
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(25.0),
                      child: InkWell(
                        child: Center(
                          child: Padding(
                            child: Text(
                              title!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: textColor),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 1.0),
                          ),
                        ),
                        onTap: onTap,
                      ),
                    )
                  : Material(
                      elevation: 2.0,
                      child: InkWell(
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(loadingColor!),
                          ),
                        ),
                        onTap: onTap,
                      ),
                      color: color,
                      shape: CircleBorder(),
                    ))),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    buttonController.addListener(()
    {
      if (buttonController.isCompleted) {}
    });
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}

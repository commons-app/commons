import 'package:flutter/material.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressed;
  final Function() onCameraPressed;
  final Function() onGalleryPressed;

  final String tooltip;
  final IconData icon;

  FancyFab(
      {this.onPressed,
      this.tooltip,
      this.icon,
      this.onCameraPressed,
      this.onGalleryPressed});

  @override
  _FancyFabState createState() =>
      _FancyFabState(onCameraPressed, onGalleryPressed);
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  Function() onCameraPressed;
  Function() onGalleryPressed;

  _FancyFabState(this.onCameraPressed, this.onGalleryPressed);

  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget gallery() {
    return Container(
      child: FloatingActionButton(
        onPressed: onGalleryPressed,
        tooltip: 'Gallery',
        heroTag: "GalleryButton",
        child: Icon(Icons.image),
      ),
    );
  }

  Widget camera() {
    return Container(
      child: FloatingActionButton(
        onPressed: onCameraPressed,
        heroTag: "CameraButton",
        tooltip: 'Camera',
        child: Icon(Icons.photo_camera),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        heroTag: "ToggleButton",
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: camera(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: gallery(),
        ),
        toggle(),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class BackgroundAnimationImage extends StatefulWidget {
  @override
  _BackgroundAnimationImageState createState() =>
      _BackgroundAnimationImageState();
}

class _BackgroundAnimationImageState extends State<BackgroundAnimationImage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear);

    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => Image.asset(
        'assets/images/background.jpg',
        fit: BoxFit.cover,
        width: size.width,
        height: size.height,
        alignment: FractionalOffset(_animation.value,0),
      ),
    );
  }
}

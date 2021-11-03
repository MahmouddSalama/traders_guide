import 'package:financial_dealings/screens/auth/auth_stste/auth_state.dart';
import 'package:financial_dealings/screens/auth/login/login_screen.dart';
import 'package:financial_dealings/sherd/methods/method.dart';

import '../../sherd/componant/animaiton_background.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: .2, end: 1).animate(_animationController);

    _animationController.repeat(reverse: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(seconds: 5),(){
      Methods.NavReplace(ctx: context,page: AuthState());
    });
    return Scaffold(
      body: Stack(
        children: [
          BackgroundAnimationImage(),
          Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (ctx, _) =>
                  Opacity(
                    opacity: _animation.value,
                    child: Text(
                      'دليل التجار',
                      style: GoogleFonts.aBeeZee(
                        fontWeight: FontWeight.w700,
                        fontSize: 51,
                        color: Colors.white,
                      ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

}

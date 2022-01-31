import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout/IntroPage.dart';

import 'ColorCategory.dart';
import 'Constants.dart';
import 'HomeWidget.dart';
import 'PrefData.dart';
import 'SizeConfig.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> with TickerProviderStateMixin {
  bool isFirst = true;
  // AnimationController? controller;
  // Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    // controller = AnimationController(
    //     duration: const Duration(milliseconds: 1000), vsync: this);
    // animation = CurvedAnimation(parent: controller!, curve: Curves.easeIn);
    //
    // /*animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     controller.reverse();
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    // });*/
    //
    // controller!.forward();

    _getIsFirst();
  }

  _getIsFirst() async {
    isFirst = await PrefData().getIsFirstIntro();
    bool isIntro = await PrefData.getIsIntro();

    if (isIntro) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => IntroPage()));
    } else {
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeWidget(0)));
      });
    }
  }

  // ThemeData themeData = new ThemeData(
  //     primaryColor: primaryColor,
  //     primaryColorDark: primaryColor,
  //     accentColor: accentColor);

  ThemeData themeData = new ThemeData(
      primaryColor: primaryColor,
      primaryColorDark: primaryColor, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor));

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(


      child: Image.asset(Constants.assetsImagePath+"Splash_screen.jpg",height: double.infinity,
      fit: BoxFit.cover,),


    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wallpaper_app/Screens/wallpaper_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WallpaperPage(),));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 1,child: Container()),
            Expanded(
                flex: 2,
                child: Lottie.asset('assets/lottie/splash_img.json')),
            Expanded(
                flex: 2,
                child: Text("Trending Wallpaper's",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/Api/api_helper.dart';
import 'package:wallpaper_app/Screens/splash_page.dart';
import 'package:wallpaper_app/bloc%20services/search_bloc/search_bloc.dart';

import 'Screens/wallpaper_page.dart';
import 'bloc services/bloc/wallpaper_bloc.dart';

void main() {
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => WallpaperBloc(apiHelper: ApiHelper() )),
        BlocProvider(create: (context) => SearchBloc(apiHelper: ApiHelper() )),
      ],
      child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}


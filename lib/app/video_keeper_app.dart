import 'package:flutter/material.dart';
import 'package:videokeeper_app/app/page/home/home_page.dart';
import 'package:videokeeper_app/app/page/splash/splash_page.dart';
import 'package:videokeeper_app/app/themes/theme_config.dart';

class VideoKeeperApp extends StatelessWidget {
  const VideoKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Video Keeper",
      theme: ThemeConfig.theme,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const SplashPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

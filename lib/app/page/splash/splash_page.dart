import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (router) => false),
    );
    super.initState();
  }

  Future<String?> _getVersionApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Video Keeper',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Colors.indigo,
                ),
              ),
            ]),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: _getVersionApp(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'Versão ${snapshot.data}',
                    style: const TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

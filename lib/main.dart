import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videokeeper_app/app/services/media/media_services.dart';

import 'app/video_keeper_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
    create: (context) => MediaServices(),
    child: const VideoKeeperApp(),
  ));
}

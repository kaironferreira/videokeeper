import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:videokeeper_app/app/core/exceptions/media_services_exception.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MediaServices with ChangeNotifier {
  final youtube = YoutubeExplode();
  late String imagePath;
  late String duration;
  late String title;
  int progress = 0;
  late String _localPath;

  Future<bool> checkPermissions(TargetPlatform? platform) async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return true;
  }

  Future<String?> _findLocalPath(TargetPlatform? platform) async {
    if (platform == TargetPlatform.android) {
      return "/sdcard/download";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }

  Future<void> preparedSaveDir(TargetPlatform? platform) async {
    _localPath = (await _findLocalPath(platform))!;

    final savedDir = Directory(_localPath);
    bool hasExited = await savedDir.exists();
    if (!hasExited) {
      savedDir.create();
    }
  }

  Future<void> download(String? url) async {
    try {
      final video = await youtube.videos.get(url);
      final manifest = await youtube.videos.streamsClient.getManifest(url);
      var streams = manifest.muxed.last;

      var fileName = '${video.title}.${streams.container.name}'
          .replaceAll(r'\', '')
          .replaceAll('/', '')
          .replaceAll('*', '')
          .replaceAll('?', '')
          .replaceAll('"', '')
          .replaceAll('<', '')
          .replaceAll('>', '')
          .replaceAll('|', '');

      final file = File('$_localPath/$fileName');
      if (file.existsSync()) {
        file.deleteSync();
      }

      var fileSize = streams.size.totalBytes;

      var count = 0;

      var videoStream = youtube.videos.streamsClient.get(streams);

      var output = file.openWrite(mode: FileMode.writeOnlyAppend);

      await for (final data in videoStream) {
        count += data.length;

        progress = ((count / fileSize) * 100).ceil();
        notifyListeners();

        output.add(data);
      }

      imagePath = 'https://img.youtube.com/vi/${video.id}/0.jpg';
      title = video.title;
      duration = video.duration.toString();

      await output.close();
    } on YoutubeExplode catch (e, s) {
      log('Erro ao realizar download', error: e, stackTrace: s);
      throw MediaServicesException(message: 'Falha ao realizar Download');
    }
  }
}

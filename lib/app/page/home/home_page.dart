import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:videokeeper_app/app/services/media/media_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _url = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late bool _permissionReady;
  late TargetPlatform? platform;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
  }

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  void _showErrorDialog(String error) {
    showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.black.withOpacity(0.90),
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          width: double.infinity,
          height: 250,
          padding: const EdgeInsets.all(12),
          color: Colors.red.shade300,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 12,
                  bottom: 16,
                ),
                child: Text(
                  'Atenção',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(error),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: double.infinity,
                height: 36,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Fechar')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(String title, String duration, String imagePath) {
    Dialog alertDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: double.infinity,
        height: 220,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                top: 12,
                bottom: 16,
              ),
              child: Text(
                'Download concluido',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imagePath,
                  width: 120,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                              text: 'Titulo: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: '${title.substring(0, 50)}...'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                              text: 'Duração: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: duration.toString().substring(0, 7)),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Fechar')),
            ),
          ],
        ),
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.black.withOpacity(0.90),
      builder: (_) => alertDialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaRepository = Provider.of<MediaServices>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Keeper'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cloud_download_outlined,
                    size: 80,
                    color: Colors.indigo,
                  ),
                  const Text(
                    'Baixe seus vídeos favoritos do Youtube',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  TextFormField(
                    controller: _url,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Cole o link do vídeo aqui.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Cole o link do vídeo aqui.',
                      suffixIcon: _url.text.isEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.paste,
                                color: Colors.indigo,
                              ),
                              onPressed: () async {
                                final clipboardData = await Clipboard.getData(
                                    Clipboard.kTextPlain);

                                setState(() {
                                  _url.text = clipboardData?.text ?? '';
                                });
                              },
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.indigo,
                              ),
                              onPressed: () {
                                setState(() {
                                  _url.text = '';
                                  mediaRepository.progress = 0;
                                });
                              },
                            ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.indigo,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  mediaRepository.progress == 0
                      ? SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            child: const Text(
                              "Baixar",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _permissionReady = await mediaRepository
                                    .checkPermissions(platform);

                                if (_permissionReady) {
                                  await mediaRepository
                                      .preparedSaveDir(platform);

                                  try {
                                    await mediaRepository.download(_url.text);
                                    _showDialog(
                                      mediaRepository.title,
                                      mediaRepository.duration,
                                      mediaRepository.imagePath,
                                    );
                                  } catch (e, s) {
                                    log('Falha no Download',
                                        error: e, stackTrace: s);
                                    _showErrorDialog(e.toString());
                                  }
                                }
                              }
                            },
                          ),
                        )
                      : LinearPercentIndicator(
                          lineHeight: 48.0,
                          percent: double.parse(
                                  mediaRepository.progress.toString()) /
                              100,
                          center: Text(
                            'Baixando ${mediaRepository.progress.toString()}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          barRadius: const Radius.circular(2),
                          progressColor: Colors.indigo,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

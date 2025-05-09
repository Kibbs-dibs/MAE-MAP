// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class CameraAccessScreen extends StatefulWidget {
  const CameraAccessScreen({super.key});

  @override
  State<CameraAccessScreen> createState() => _CameraAccessScreenState();
}

class _CameraAccessScreenState extends State<CameraAccessScreen> {
  final String _viewId = 'webcam-view';

  @override
  void initState() {
    super.initState();

    // Register web view for live webcam
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final video =
          html.VideoElement()
            ..width = 640
            ..height = 480
            ..autoplay = true;

      html.window.navigator.mediaDevices
          ?.getUserMedia({'video': true})
          .then((stream) {
            video.srcObject = stream;
          })
          .catchError((e) {
            print("Camera access error: $e");
          });

      return video;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Webcam Live Preview')),
      body: Center(child: HtmlElementView(viewType: _viewId)),
    );
  }
}

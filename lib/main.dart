import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ml_kit/page/barcode_scanner/barcode_view.dart';
import 'package:ml_kit/page/face_detector/face_detector_view.dart';
import 'package:ml_kit/page/object_detector/object_detector_view.dart';
import 'package:ml_kit/page/text_recognizer/text_recognizer_view.dart';
import 'package:ml_kit/main.dart';
import 'package:ml_kit/page/text_translation/text_translation_view.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

List<CameraDescription> cameras = [];

/// Physical devices only
/// Everything copied from https://github.com/flutter-ml/google_ml_kit_flutter/tree/master/packages/google_ml_kit/example

Future<List<dynamic>> encode(String input) async {
  const String regex = "r'[^p{L}p{N}]'";
  final newString = input.replaceAll(RegExp(regex), '');
  log("$newString");
  List<dynamic> result = List.filled(1 * 64, 0);
  result = newString.characters.map((e) => e.codeUnitAt(0)).toList();
  List<int> wrapper = List.filled(1 * 64, 0).flatten();

  for (var i = 0; i < result.length; i++) {
    wrapper[i] = result[i];
  }

  return wrapper.reshape([1, 64]).toList();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const BarcodeScannerView(),
                    ));
                  },
                  child: const Text("Barcode scanner"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TextRecognizerView(),
                    ));
                  },
                  child: const Text("Text recognizer"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const FaceDetectorView()));
                  },
                  child: const Text("Face detector"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LanguageTranslatorView()));
                  },
                  child: const Text("Language translation"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ObjectDetectorView()));
                  },
                  child: const Text("Object detection"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

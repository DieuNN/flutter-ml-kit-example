import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ml_kit/page/barcode_scanner/barcode_view.dart';
import 'package:ml_kit/page/face_detector/face_detector_view.dart';
import 'package:ml_kit/page/object_detector/object_detector_view.dart';
import 'package:ml_kit/page/text_recognizer/text_recognizer_view.dart';
import 'package:ml_kit/page/text_translation/text_translation_view.dart';

List<CameraDescription> cameras = [];

void main() async {
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
      home: kIsWeb ? const Text("Web is not supported") : const HomePage(),
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

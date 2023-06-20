// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:ml_kit/main.dart';
import 'package:ml_kit/page/activity_indicator.dart';
import 'package:ml_kit/page/captured_view.dart';

import '../camera_view.dart';
import 'face_detector_painter.dart';

class FaceDetectorView extends StatefulWidget {
  const FaceDetectorView({super.key});

  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  bool _isContainFace = false;
  late CameraView cameraView;
  late CameraController? cameraController;

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  void initState() {
    cameraView = CameraView(
      title: 'Face Detector',
      customPaint: _customPaint,
      controller: CameraController(cameras.first, ResolutionPreset.medium),
      text: _text,
      onImage: (inputImage) {
        processImage(inputImage);
      },
      initialDirection: CameraLensDirection.front,
    );
     cameraController = cameraView.controller;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    cameraController?.initialize().then((value) => {setState(() {})});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cameraView,
      floatingActionButton: Visibility(
        visible: _isContainFace,
        child: FloatingActionButton(
          onPressed: () async {
            XFile? file;
            if (_isContainFace) {
              file = await cameraController?.takePicture();
              log(file.toString());
            }

            if (file == null && !mounted) {
              Toast().show("File broken",
                  Future.value("Error when display file"), context, this);
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CapturedView(imagePath: file!.path),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final faces = await _faceDetector.processImage(inputImage);

    if (faces.isNotEmpty) {
      setState(() {
        _isContainFace = true;
      });
    } else {
      setState(() {
        _isContainFace = false;
      });
    }

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(
          faces,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      _text = text;
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}

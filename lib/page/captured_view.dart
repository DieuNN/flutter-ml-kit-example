import 'dart:io';

import 'package:flutter/material.dart';

class CapturedView extends StatelessWidget {
  final String imagePath;
  const CapturedView({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}

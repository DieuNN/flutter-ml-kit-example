import 'dart:io';
import 'dart:ui';

import 'package:google_ml_kit/google_ml_kit.dart';

double translateX(
  double x,
  InputImageRotation rotation,
  Size size,
  Size absoluteSize,
) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
      return x *
          size.width /
          (Platform.isIOS ? absoluteSize.width : absoluteSize.height);
    case InputImageRotation.rotation270deg:
      return size.width -
          x *
              size.width /
              (Platform.isIOS
                  ? absoluteSize.width
                  : absoluteSize.height);
    default:
      return x * size.width / absoluteSize.width;
  }
}

double translateY(
    double y, InputImageRotation rotation, Size size, Size absoluteImageSize) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
    case InputImageRotation.rotation270deg:
      return y *
          size.height /
          (Platform.isIOS ? absoluteImageSize.height : absoluteImageSize.width);
    default:
      return y * size.height / absoluteImageSize.height;
  }
}

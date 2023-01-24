import 'package:flutter/material.dart';

class ScreenSize {
  static MediaQueryData _mediaQueryData = const MediaQueryData();
  static double? deviceHeight;
  static double? deviceWidth;
  static Orientation? deviceOrientation;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    deviceHeight = _mediaQueryData.size.height;
    deviceWidth = _mediaQueryData.size.width;
    deviceOrientation = _mediaQueryData.orientation;
  }
}

double getProrataHeight(double inHeight) {
  double? screenHeight = ScreenSize.deviceHeight;
  //I choose iPhone 14 pro as the reference device with logical screen size 393 x 852
  return (inHeight / 852.0) * screenHeight!;
}

double getProrataWidth(double inWidth) {
  double? screenWidth = ScreenSize.deviceWidth;
  //I choose iPhone 14 pro as the reference device with logical screen size 393 x 852
  return (inWidth / 393.0) * screenWidth!;
}

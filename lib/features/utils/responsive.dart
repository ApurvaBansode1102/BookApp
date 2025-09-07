import 'package:flutter/material.dart';

class Responsive {
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  static double padding(BuildContext context, {double mobile = 16, double tablet = 32}) =>
      isTablet(context) ? tablet : mobile;

  static double fontSize(BuildContext context, {double mobile = 16, double tablet = 24}) =>
      isTablet(context) ? tablet : mobile;
}
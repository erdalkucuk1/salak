import 'package:flutter/material.dart';
import '../utils/screen_utils.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (ScreenUtils.isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    }
    if (ScreenUtils.isTablet(context)) {
      return tablet ?? mobile;
    }
    return mobile;
  }
}

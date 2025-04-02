import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget deskstopBody;
  const ResponsiveLayout(
      {super.key, required this.mobileBody, required this.deskstopBody});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 800) {
        return deskstopBody;
      } else {
        return mobileBody;
      }
    });
  }
}

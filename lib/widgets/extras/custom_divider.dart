import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double thickness;
  const CustomDivider({super.key, this.thickness = 1});

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: 40,
      endIndent: 40,
      height: 30,
      thickness: thickness,
    );
  }
}

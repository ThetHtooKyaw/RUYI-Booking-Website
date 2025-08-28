import 'package:flutter/material.dart';

class ListViewShadow extends StatelessWidget {
  final double shadowOpacity;
  const ListViewShadow({super.key, required this.shadowOpacity});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 0.8,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(shadowOpacity),
              blurRadius: 6,
              spreadRadius: 0.6,
            )
          ],
        ),
      ),
    );
  }
}

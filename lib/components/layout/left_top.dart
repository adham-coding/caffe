import 'package:flutter/material.dart';
import 'package:caffe/components/blur_box.dart';

class LeftTop extends StatelessWidget {
  const LeftTop({super.key});

  @override
  Widget build(BuildContext context) {
    return const BlurBox(
      height: 65.0,
      child: Center(
        child: Text(
          "Welcome to our Cafe!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 21.0),
        ),
      ),
    );
  }
}

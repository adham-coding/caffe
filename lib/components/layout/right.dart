import 'package:flutter/material.dart';
import 'package:caffe/components/blur_box.dart';
import 'package:caffe/constants/sizes.dart';

class Right extends StatelessWidget {
  const Right({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: BlurBox(
        margin: EdgeInsets.only(left: gap / 2),
        // blur: 20.0,
      ),
    );
  }
}

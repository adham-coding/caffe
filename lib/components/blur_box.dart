import 'package:flutter/material.dart';
import 'package:caffe/constants/colors.dart';
import 'package:caffe/constants/sizes.dart';
import 'dart:ui';

class BlurBox extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final double blur;
  final double radius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color color;

  const BlurBox({
    super.key,
    this.child,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.blur = backdropBlur,
    this.radius = borderRadius,
    this.color = blurColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? const EdgeInsets.all(0.0),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: blur, sigmaX: blur),
            child: Container(
              padding: padding,
              color: color,
              width: width,
              height: height,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

const double gap = 12.0;
const double backdropBlur = 28.0;
const double borderRadius = 10.0;
const TextStyle textStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.normal,
  fontFamily: "UbuntuSans",
);
ButtonStyle buttonStyle = OutlinedButton.styleFrom(
  textStyle: textStyle,
  padding: const EdgeInsets.symmetric(vertical: 21.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(borderRadius),
    ),
  ),
);

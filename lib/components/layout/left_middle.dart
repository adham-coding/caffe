import 'package:flutter/material.dart';
import 'package:caffe/models/refresher.dart';
import 'package:caffe/components/blur_box.dart';
import 'package:caffe/components/purchases.dart';
import 'package:caffe/models/purchase.dart';
import 'package:caffe/constants/sizes.dart';

class LeftMiddle extends StatelessWidget {
  final Refresher refresher;
  final List<Purchase> purchases;

  const LeftMiddle({
    super.key,
    required this.refresher,
    required this.purchases,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlurBox(
        margin: const EdgeInsets.symmetric(vertical: gap),
        child: Purchases(purchases: purchases, refresher: refresher),
      ),
    );
  }
}

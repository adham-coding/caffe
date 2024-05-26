import 'package:flutter/material.dart';
import 'package:caffe/models/balance.dart';
import 'package:caffe/models/refresher.dart';
import 'package:caffe/models/purchase.dart';
import 'package:caffe/utils/functions.dart';
import 'package:caffe/components/blur_box.dart';
import 'package:caffe/constants/sizes.dart';

class LeftBottom extends StatefulWidget {
  final Refresher refresher;
  final List<Purchase> purchases;

  const LeftBottom({
    super.key,
    required this.refresher,
    required this.purchases,
  });

  @override
  State<LeftBottom> createState() => _LeftBottomState();
}

class _LeftBottomState extends State<LeftBottom> {
  final Balance balance = Balance();

  @override
  void initState() {
    super.initState();

    widget.refresher.add(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(fontSize: 18.0);

    balance.total = widget.purchases
        .fold(0, (total, Purchase p) => total + p.price * p.quantity);

    balance.discount = 5;
    balance.saving = balance.total * balance.discount / 100;
    balance.summary = balance.total - balance.saving;
    balance.moneyBack = balance.payed - balance.summary;
    balance.moneyBack = balance.moneyBack < 0 ? 0 : balance.moneyBack;

    return SizedBox(
      height: 200.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Expanded>[
          Expanded(
            child: BlurBox(
              margin: const EdgeInsets.only(right: gap / 2),
              child: Padding(
                padding: const EdgeInsets.all(gap * 2),
                child: Column(
                  children: <Expanded>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Text>[
                          Text("Total:", style: textStyle),
                          Text(
                            humanizedNumber(balance.total),
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Text>[
                          Text("Discount:", style: textStyle),
                          Text(
                            "${humanizedNumber(balance.discount)} %",
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Text>[
                          Text("Saving:", style: textStyle),
                          Text(
                            humanizedNumber(balance.saving),
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: BlurBox(
              margin: const EdgeInsets.only(left: gap / 2),
              child: Padding(
                padding: const EdgeInsets.all(gap * 2),
                child: Column(
                  children: <Expanded>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Text>[
                          Text("Summary:", style: textStyle),
                          Text(
                            humanizedNumber(balance.summary),
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Text>[
                          Text("Payed:", style: textStyle),
                          Text(
                            humanizedNumber("${balance.payed}"),
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Text>[
                          Text("Money back:", style: textStyle),
                          Text(
                            humanizedNumber(balance.moneyBack),
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

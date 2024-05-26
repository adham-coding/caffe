import 'package:flutter/material.dart';
import 'package:caffe/models/refresher.dart';
import 'package:caffe/components/pop_up.dart';
import 'package:caffe/constants/colors.dart';
import 'package:caffe/models/purchase.dart';
import 'package:caffe/utils/functions.dart';
import 'package:caffe/constants/sizes.dart';

class Purchases extends StatefulWidget {
  final Refresher refresher;
  final List<Purchase> purchases;

  const Purchases({
    super.key,
    required this.refresher,
    required this.purchases,
  });

  @override
  State<Purchases> createState() => _PurchasesState();
}

class _PurchasesState extends State<Purchases> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    widget.refresher.add(() => setState(() {}));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future(() async {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });

    return ListView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(gap, gap / 6, gap, gap),
      itemCount: widget.purchases.length,
      itemBuilder: (context, i) {
        return PopUp(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: gap / 2,
              vertical: gap,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: borderColor),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 28.0,
                  child: Text("${i + 1}", textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: gap / 2),
                    child: Text(widget.purchases[i].name.toString()),
                  ),
                ),
                Text(humanizedNumber(widget.purchases[i].price)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: gap / 2),
                  child: Text("x"),
                ),
                Text(widget.purchases[i].quantity.toString()),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: gap / 2),
                  child: Text("="),
                ),
                Text(
                  humanizedNumber(
                    (widget.purchases[i].price * widget.purchases[i].quantity),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

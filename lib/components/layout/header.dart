import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:window_manager/window_manager.dart';
import 'package:intl/intl.dart';
import 'package:caffe/constants/sizes.dart';
import 'package:caffe/components/blur_box.dart';

class Header extends StatelessWidget {
  final bool isOnline;
  final String screen;

  const Header({super.key, required this.isOnline, required this.screen});

  @override
  Widget build(BuildContext context) {
    return BlurBox(
      margin: const EdgeInsets.only(bottom: gap),
      padding: const EdgeInsets.symmetric(horizontal: gap * 1.5),
      height: 55.0,
      child: Row(
        children: <Expanded>[
          Expanded(
            child: Row(
              children: [
                IconButton(
                  iconSize: 22.0,
                  padding: const EdgeInsets.all(0.0),
                  color: isOnline ? Colors.greenAccent : Colors.redAccent,
                  constraints: const BoxConstraints(
                    minWidth: 30.0,
                    maxWidth: 30.0,
                    maxHeight: 30.0,
                    minHeight: 30.0,
                  ),
                  icon: const Icon(CupertinoIcons.circle_fill),
                  onPressed: () async {
                    windowManager.setFullScreen(
                      !await windowManager.isFullScreen(),
                    );
                  },
                ),
                Text(
                  isOnline ? "Online" : "Offline",
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              screen.isEmpty ? "" : "Screen ( $screen )",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22.0),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Text(
                  DateFormat("HH : mm : ss").format(DateTime.now()),
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 24.0),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PopUp extends StatefulWidget {
  final Widget child;

  const PopUp({super.key, required this.child});

  @override
  State<PopUp> createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 250),
    vsync: this,
  )..forward(from: 0);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.97, end: 1).animate(_animation),
      child: FadeTransition(opacity: _animation, child: widget.child),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

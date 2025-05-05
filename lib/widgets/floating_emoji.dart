import 'package:flutter/material.dart';
import 'dart:math';

class FloatingEmoji extends StatefulWidget {
  final String emoji;
  FloatingEmoji({required this.emoji, Key? key}) : super(key: key);

  @override
  _FloatingEmojiState createState() => _FloatingEmojiState();
}

class _FloatingEmojiState extends State<FloatingEmoji> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double startX;

  @override
  void initState() {
    super.initState();
    startX = Random().nextDouble() * 0.8 + 0.1; // random horizontal start
    _controller = AnimationController(
      duration: Duration(milliseconds: 1800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width * startX,
      bottom: 80,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: Transform.translate(
              offset: Offset(0, -200 * (1 - _animation.value)),
              child: Text(widget.emoji, style: TextStyle(fontSize: 40)),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
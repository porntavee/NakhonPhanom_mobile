import 'package:flutter/material.dart';

class BlankLoading extends StatefulWidget {
  BlankLoading({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  _BlankLoading createState() => _BlankLoading();
}

class _BlankLoading extends State<BlankLoading>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  dispose() {
    _controller!.dispose(); // you need this
    super.dispose();
  }

  Animatable<Color?> background = TweenSequence<Color?>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.black.withAlpha(20),
        end: Colors.black.withAlpha(50),
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.black.withAlpha(50),
        end: Colors.black.withAlpha(20),
      ),
    ),
  ]);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: AnimatedBuilder(
        animation: _controller!,
        builder: (context, child) {
          return Container(
            alignment: Alignment.topCenter,
            height: widget.height,
            decoration: BoxDecoration(
              color: background.evaluate(
                AlwaysStoppedAnimation(_controller!.value),
              ),
            ),
          );
        },
      ),
    );
  }
}

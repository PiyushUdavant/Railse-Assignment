import 'package:flutter/material.dart';

class SlideFadeFromRight extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offsetX;

  const SlideFadeFromRight({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.offsetX = 50.0,
  });

  @override
  SlideFadeFromRightState createState() => SlideFadeFromRightState();
}

class SlideFadeFromRightState extends State<SlideFadeFromRight>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Move MediaQuery here

    _slide = Tween<Offset>(
      begin: Offset(widget.offsetX / screenWidth, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(_slide.value.dx * screenWidth, 0),
            child: widget.child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

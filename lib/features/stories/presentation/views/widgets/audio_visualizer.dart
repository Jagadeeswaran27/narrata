import 'dart:math';
import 'package:flutter/material.dart';

class AudioVisualizer extends StatefulWidget {
  final bool isPlaying;
  final Color color;

  const AudioVisualizer({
    super.key,
    required this.isPlaying,
    required this.color,
  });

  @override
  State<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer> {
  final Random _random = Random();
  final List<double> _heights = List.generate(4, (index) => 0.2);
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    if (widget.isPlaying) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(covariant AudioVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _startAnimation();
      } else {
        _stopAnimation();
      }
    }
  }

  void _startAnimation() async {
    if (_isRunning) return;
    _isRunning = true;
    while (_isRunning && mounted) {
      setState(() {
        for (int i = 0; i < _heights.length; i++) {
          _heights[i] = _random.nextDouble() * 0.8 + 0.2; // 0.2 to 1.0
        }
      });
      await Future.delayed(const Duration(milliseconds: 250));
    }
  }

  void _stopAnimation() {
    _isRunning = false;
    setState(() {
      for (int i = 0; i < _heights.length; i++) {
        _heights[i] = 0.2;
      }
    });
  }

  @override
  void dispose() {
    _isRunning = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(4, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 4,
            height: widget.isPlaying ? 24 * _heights[index] : 4,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}

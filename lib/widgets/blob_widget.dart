import 'package:flutter/material.dart';
import 'dart:math' as math;

class BlobWidget extends StatefulWidget {
  final bool isListening;
  final bool isSpeaking;
  final double audioLevel;

  const BlobWidget({
    super.key,
    this.isListening = false,
    this.isSpeaking = false,
    this.audioLevel = 0.0,
  });

  @override
  State<BlobWidget> createState() => _BlobWidgetState();
}

class _BlobWidgetState extends State<BlobWidget>
    with TickerProviderStateMixin {
  late AnimationController _morphController;
  late AnimationController _blinkController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 2 + math.Random().nextInt(3)));
      if (!mounted) return false;
      _blinkController.forward().then((_) => _blinkController.reverse());
      return true;
    });
  }

  @override
  void dispose() {
    _morphController.dispose();
    _blinkController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_morphController, _floatController]),
      builder: (context, child) {
        double scale = 1.0;
        if (widget.isListening) scale = 1.15 + widget.audioLevel * 0.3;
        if (widget.isSpeaking) scale = 1.1 + math.sin(_morphController.value * 10) * 0.05;

        return Transform.translate(
          offset: Offset(0, math.sin(_floatController.value * math.pi) * 8),
          child: Transform.scale(
            scale: scale,
            child: SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFF8B5CF6),
                          Color(0xFF3B82F6),
                          Color(0xFF6366F1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(
                        80 + math.sin(_morphController.value * math.pi * 2) * 20,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF8B5CF6).withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 10,
                        )
                      ],
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _blinkController,
                    builder: (context, _) {
                      double eyeHeight = 12 - _blinkController.value * 10;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 18,
                            height: eyeHeight < 2 ? 2 : eyeHeight,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(width: 30),
                          Container(
                            width: 18,
                            height: eyeHeight < 2 ? 2 : eyeHeight,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  if (widget.isSpeaking)
                    Positioned(
                      bottom: 65,
                      child: Container(
                        width: 20 + math.sin(_morphController.value * 10) * 10,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

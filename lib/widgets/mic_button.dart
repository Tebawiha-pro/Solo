import 'package:flutter/material.dart';

class MicButton extends StatelessWidget {
  final bool isListening;
  final bool isSpeaking;
  final VoidCallback onLongPressStart;
  final VoidCallback onLongPressEnd;
  final VoidCallback onStopSpeaking;

  const MicButton({
    super.key,
    required this.isListening,
    required this.isSpeaking,
    required this.onLongPressStart,
    required this.onLongPressEnd,
    required this.onStopSpeaking,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => onLongPressStart(),
      onLongPressEnd: (_) => onLongPressEnd(),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: isListening ? 80 : 70,
        height: isListening ? 80 : 70,
        decoration: BoxDecoration(
          color: isSpeaking ? Colors.black : (isListening ? Color(0xFF8B5CF6) : Colors.black),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (isListening ? Color(0xFF8B5CF6) : Colors.black).withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            )
          ],
        ),
        child: Icon(
          isSpeaking ? Icons.close : (isListening ? Icons.graphic_eq : Icons.mic),
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}

class Waveform extends StatefulWidget {
  const Waveform({super.key});

  @override
  State<Waveform> createState() => _WaveformState();
}

class _WaveformState extends State<Waveform> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 600))..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            double h = 10 + (20 * (0.5 + 0.5 * (i % 2 == 0 ? controller.value : 1 - controller.value)));
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 3),
              width: 4,
              height: h,
              decoration: BoxDecoration(
                color: Color(0xFF8B5CF6),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        );
      },
    );
  }
}

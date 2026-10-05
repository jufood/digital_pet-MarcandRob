import 'package:flutter/material.dart';

class AnimatedMeter extends StatelessWidget {
  final String label;
  final int value;

  const AnimatedMeter({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$value / 100',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: 0,
            end: value / 100,
          ),
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          builder: (context, animatedValue, child) {
            return LinearProgressIndicator(
              value: animatedValue,
              minHeight: 12,
              borderRadius: BorderRadius.circular(10),
            );
          },
        ),
      ],
    );
  }
}
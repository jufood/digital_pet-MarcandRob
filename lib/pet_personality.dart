import 'package:flutter/material.dart';

class PetPersonality extends StatelessWidget {
  final String petName;
  final int happiness;
  final int hunger;

  const PetPersonality({
    super.key,
    required this.petName,
    required this.happiness,
    required this.hunger,
  });

  Color get moodColor {
    if (happiness > 70) {
      return Colors.green;
    } else if (happiness >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  String get moodLabel {
    if (happiness > 70) {
      return 'Happy';
    } else if (happiness >= 30) {
      return 'Neutral';
    } else {
      return 'Unhappy';
    }
  }

  String get petMessage {
    if (hunger > 80) {
      return "I'm starving!";
    }

    if (happiness <= 30) {
      return 'Play with me?';
    }

    return "Hi, I'm $petName!";
  }

  double get petScale {
    if (happiness > 70) {
      return 1.06;
    } else if (happiness < 30) {
      return 0.94;
    } else {
      return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Column(
      children: [
        AnimatedScale(
          scale: petScale,
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              moodColor,
              BlendMode.modulate,
            ),
            child: Image.asset(
              'assets/pet.png',
              width: 160,
              height: 160,
              fit: BoxFit.contain,
            ),
          ),
        ),

        const SizedBox(height: 20),

        AnimatedSwitcher(
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 300),
          child: Text(
            petMessage,
            key: ValueKey(petMessage),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'Mood: $moodLabel',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: moodColor == Colors.yellow
                ? Colors.orange.shade700
                : moodColor,
          ),
        ),
      ],
    );
  }
}
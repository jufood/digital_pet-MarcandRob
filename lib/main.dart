import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const DigitalPetApp());
}

class DigitalPetApp extends StatelessWidget {
  const DigitalPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Pet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const PetScreen(),
    );
  }
}

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  // ----- State -----
  int _happiness = 50;
  int _hunger = 50;
  String _petName = 'Pip';
  bool _gameOver = false;
  bool _hasWon = false;

  Timer? _hungerTimer;
  Timer? _highMoodTimer;
  final TextEditingController _nameController = TextEditingController();

  // ----- Helpers -----
  int _clampMeter(int value) => value.clamp(0, 100).toInt();

  Color get _moodColor {
    if (_happiness > 70) return Colors.green;
    if (_happiness >= 30) return Colors.yellow;
    return Colors.red;
  }

  String get _moodLabel {
    if (_happiness > 70) return 'Happy';
    if (_happiness >= 30) return 'Neutral';
    return 'Unhappy';
  }

  double get _petScale =>
      _happiness > 70 ? 1.06 : (_happiness < 30 ? 0.94 : 1.0);

  String get _petMessage {
    if (_gameOver) return 'I need a rest.';
    if (_hasWon) return 'Best day ever!';
    if (_hunger > 80) return "I'm starving!";
    if (_happiness <= 30) return 'Play with me?';
    return "Hi, I'm $_petName!";
  }

  bool get _isTerminal => _gameOver || _hasWon;

  // ----- Lifecycle -----
  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    _highMoodTimer?.cancel();
    _nameController.dispose();
    super.dispose();
  }

  void _startHungerTimer() {
    _hungerTimer?.cancel();
    _hungerTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!mounted || _isTerminal) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_hunger + 5 > 100) {
          _hunger = 100;
          _happiness = _clampMeter(_happiness - 20);
        } else {
          _hunger += 5;
        }
      });
      _updateOutcome();
    });
  }

  // ----- Actions -----
  void _feedPet() {
    if (_isTerminal) return;
    final nextHunger = _clampMeter(_hunger - 10);
    final happinessChange = nextHunger < 30 ? -20 : 10;
    final nextHappiness = _clampMeter(_happiness + happinessChange);

    setState(() {
      _hunger = nextHunger;
      _happiness = nextHappiness;
    });
    _updateOutcome();
  }

  void _playWithPet() {
    if (_isTerminal) return;
    setState(() {
      _happiness = _clampMeter(_happiness + 10);
      _hunger = _clampMeter(_hunger + 5);
    });
    _updateOutcome();
  }

  void _resetPet() {
    _hungerTimer?.cancel();
    _highMoodTimer?.cancel();
    _hungerTimer = null;
    _highMoodTimer = null;

    setState(() {
      _happiness = 50;
      _hunger = 50;
      _gameOver = false;
      _hasWon = false;
    });
    _startHungerTimer();
  }

  void _setName() {
    final name = _nameController.text.trim();
    setState(() {
      _petName = name.isEmpty ? 'Pip' : name;
    });
  }

  // ----- Outcomes -----
  void _updateOutcome() {
    if (_isTerminal) return;

    // Loss
    if (_hunger == 100 && _happiness <= 10) {
      _highMoodTimer?.cancel();
      _highMoodTimer = null;
      _hungerTimer?.cancel();
      setState(() => _gameOver = true);
      return;
    }

    // Win timer management
    if (_happiness <= 80) {
      _highMoodTimer?.cancel();
      _highMoodTimer = null;
      return;
    }

    _highMoodTimer ??= Timer(const Duration(minutes: 3), () {
      _highMoodTimer = null;
      if (!mounted || _isTerminal || _happiness <= 80) return;
      setState(() => _hasWon = true);
      _hungerTimer?.cancel();
    });
  }

  // ----- UI -----
  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final animDuration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 300);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Pet'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Pet name',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _setName(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isTerminal ? null : _setName,
                    child: const Text('Set'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Pet image with mood tint
              Center(
                child: AnimatedScale(
                  scale: _petScale,
                  duration: animDuration,
                  curve: Curves.easeOutBack,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      _moodColor,
                      BlendMode.modulate,
                    ),
                    child: Image.asset(
                      'assets/pet.png',
                      height: 160,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                          color: _moodColor.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text('🐾', style: TextStyle(fontSize: 60)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Mood label + message
              Center(
                child: Text(
                  _moodLabel,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _moodColor,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(_petMessage, style: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 20),

              // Meters
              _meter('Happiness', _happiness, Colors.pink, reduceMotion),
              const SizedBox(height: 8),
              _meter('Hunger', _hunger, Colors.orange, reduceMotion),
              const SizedBox(height: 20),

              // Outcome banner
              if (_gameOver)
                const Card(
                  color: Colors.redAccent,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Game over! Your pet needs care.',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              if (_hasWon)
                const Card(
                  color: Colors.green,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      '🎉 You win! Your pet had a perfect day.',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              if (_gameOver || _hasWon) const SizedBox(height: 12),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isTerminal ? null : _feedPet,
                      icon: const Icon(Icons.restaurant),
                      label: const Text('Feed'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isTerminal ? null : _playWithPet,
                      icon: const Icon(Icons.sports_tennis),
                      label: const Text('Play'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _resetPet,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _meter(String label, int value, Color color, bool reduceMotion) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('$value / 100'),
          ],
        ),
        const SizedBox(height: 4),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value / 100),
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          builder: (context, v, _) => LinearProgressIndicator(
            value: v,
            color: color,
            backgroundColor: color.withValues(alpha: 0.2),
            minHeight: 10,
          ),
        ),
      ],
    );
  }
}

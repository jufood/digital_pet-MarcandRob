import 'dart:async';

import 'package:flutter/material.dart';

import 'animated_meter.dart';
import 'pet_name_input.dart';
import 'pet_personality.dart';

void main() {
  runApp(const DigitalPetApp());
}

class DigitalPetApp extends StatelessWidget {
  const DigitalPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital Pet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const DigitalPetPage(),
    );
  }
}

class DigitalPetPage extends StatefulWidget {
  const DigitalPetPage({super.key});

  @override
  State<DigitalPetPage> createState() => _DigitalPetPageState();
}

class _DigitalPetPageState extends State<DigitalPetPage> {
  String _petName = 'Pip';

  int _happiness = 50;
  int _hunger = 50;

  bool _gameOver = false;
  bool _hasWon = false;
  bool _isPaused = false;

  Timer? _hungerTimer;
  Timer? _highMoodTimer;

  final TextEditingController _nameController = TextEditingController(
    text: 'Pip',
  );

  int _clampMeter(int value) {
    return value.clamp(0, 100).toInt();
  }

  bool get _isTerminal => _gameOver || _hasWon;

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  void _startHungerTimer() {
    _hungerTimer?.cancel();

    if (_isPaused || _isTerminal) {
      return;
    }

    _hungerTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!mounted || _isPaused || _isTerminal) {
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

  void _confirmName() {
    if (_isTerminal) {
      return;
    }

    final newName = _nameController.text.trim();

    if (newName.isEmpty) {
      return;
    }

    setState(() {
      _petName = newName;
    });
  }

  void _feedPet() {
    if (_isTerminal || _isPaused) {
      return;
    }

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
    if (_isTerminal || _isPaused) {
      return;
    }

    setState(() {
      _happiness = _clampMeter(_happiness + 10);
      _hunger = _clampMeter(_hunger + 5);
    });

    _updateOutcome();
  }

  void _updateOutcome() {
    if (_isTerminal || _isPaused) {
      return;
    }

    if (_hunger == 100 && _happiness <= 10) {
      _highMoodTimer?.cancel();
      _highMoodTimer = null;

      _hungerTimer?.cancel();

      setState(() {
        _gameOver = true;
      });

      return;
    }

    if (_happiness <= 80) {
      _highMoodTimer?.cancel();
      _highMoodTimer = null;
      return;
    }

    _highMoodTimer ??= Timer(const Duration(minutes: 3), () {
      _highMoodTimer = null;

      if (!mounted || _gameOver || _isPaused || _happiness <= 80) {
        return;
      }

      setState(() {
        _hasWon = true;
      });

      _hungerTimer?.cancel();
    });
  }

  void _togglePause() {
    if (_isTerminal) {
      return;
    }

    if (!_isPaused) {
      _hungerTimer?.cancel();
      _highMoodTimer?.cancel();
      _highMoodTimer = null;

      setState(() {
        _isPaused = true;
      });
    } else {
      setState(() {
        _isPaused = false;
      });

      _startHungerTimer();
      _updateOutcome();
    }
  }

  void _resetPet() {
    _hungerTimer?.cancel();
    _highMoodTimer?.cancel();

    _hungerTimer = null;
    _highMoodTimer = null;

    setState(() {
      _petName = 'Pip';
      _nameController.text = 'Pip';

      _happiness = 50;
      _hunger = 50;

      _gameOver = false;
      _hasWon = false;
      _isPaused = false;
    });

    _startHungerTimer();
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    _highMoodTimer?.cancel();
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Digital Pet'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              PetPersonality(
                petName: _petName,
                happiness: _happiness,
                hunger: _hunger,
              ),

              const SizedBox(height: 30),

              PetNameInput(
                controller: _nameController,
                onConfirm: _confirmName,
              ),

              const SizedBox(height: 30),

              AnimatedMeter(label: 'Happiness', value: _happiness),

              const SizedBox(height: 24),

              AnimatedMeter(label: 'Hunger', value: _hunger),

              const SizedBox(height: 24),

              if (_isPaused)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Game Paused',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              if (_gameOver)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Game Over! Your pet needs care.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              if (_hasWon)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      '🎉 You Win! Your pet had a perfect day!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isTerminal || _isPaused ? null : _feedPet,
                    icon: const Icon(Icons.restaurant),
                    label: const Text('Feed'),
                  ),

                  ElevatedButton.icon(
                    onPressed: _isTerminal || _isPaused ? null : _playWithPet,
                    icon: const Icon(Icons.sports_tennis),
                    label: const Text('Play'),
                  ),

                  ElevatedButton.icon(
                    onPressed: _isTerminal ? null : _togglePause,
                    icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                    label: Text(_isPaused ? 'Resume' : 'Pause'),
                  ),

                  OutlinedButton.icon(
                    onPressed: _resetPet,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

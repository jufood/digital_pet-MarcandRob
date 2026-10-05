import 'package:flutter/material.dart';

import 'pet_personality.dart';
import 'pet_name_input.dart';
import 'animated_meter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Pet',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Digital Pet'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _petName = 'Pip';
  int _happiness = 50;
  int _hunger = 50;

  final TextEditingController _nameController =
    TextEditingController(text: 'Pip');

  void _confirmName() {
    final newName = _nameController.text.trim();

    if (newName.isEmpty) {
      return;
    }

    setState(() {
      _petName = newName;
    });
  }

  void _testFeed() {
    setState(() {
      _hunger = (_hunger - 10).clamp(0, 100);
      _happiness = (_happiness + 5).clamp(0, 100);
    });
  }

  void _testPlay() {
    setState(() {
      _happiness = (_happiness + 15).clamp(0, 100);
      _hunger = (_hunger + 5).clamp(0, 100);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),

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

              AnimatedMeter(
                label: 'Happiness',
                value: _happiness,
              ),

              const SizedBox(height: 24),

              AnimatedMeter(
                label: 'Hunger',
                value: _hunger,
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _testFeed,
                    child: const Text('Feed'),
                  ),

                  const SizedBox(width: 16),

                  ElevatedButton(
                    onPressed: _testPlay,
                    child: const Text('Play'),
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

import 'package:flutter/material.dart';

class PetNameInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onConfirm;

  const PetNameInput({
    super.key,
    required this.controller,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Pet Name',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          onPressed: onConfirm,
          icon: const Icon(Icons.check),
        ),
      ),
      onSubmitted: (_) => onConfirm(),
    );
  }
}
import 'package:flutter/material.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({super.key, required this.selectedFoods});

  final List<String> selectedFoods;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Page')),
      body: selectedFoods.isEmpty
          ? const Center(
              child: Text('No product selected.'),
            )
          : ListView.builder(
              itemCount: selectedFoods.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.fastfood),
                  title: Text(selectedFoods[index]),
                );
              },
            ),
    );
  }
}
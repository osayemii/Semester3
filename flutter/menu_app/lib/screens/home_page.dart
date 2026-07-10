import 'package:flutter/material.dart';

import 'food_page.dart';

List<String> foods = [
  'Jollof rice',
  'Meat pie',
  'Doughnut',
  'Shawarma',
  'Pizza',
  'Burger',
  'Fries',
];
List<bool> selectedFood = List.filled(foods.length, false);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _CheckboxScreenState();
}

class _CheckboxScreenState extends State<HomePage> {
  void _goToFoodPage() {
    final selectedItems = <String>[];

    for (var i = 0; i < foods.length; i++) {
      if (selectedFood[i]) {
        selectedItems.add(foods[i]);
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodPage(selectedFoods: selectedItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Menu')),
      body: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(foods[index]),
            value: selectedFood[index],
            onChanged: (value) {
              setState(() {
                selectedFood[index] = value ?? false;
              });
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _goToFoodPage,
          child: const Text('Buy now!'),
        ),
      ),
    );
  }
}

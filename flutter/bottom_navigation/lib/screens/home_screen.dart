import 'package:flutter/material.dart';

//appbar-Navigation
import './tabbar_screen.dart';
import './bottom_nav_screen.dart';

//image
// import './image_screen.dart';
//buttons
//dialogs
//form
//text
//container


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = {
      //Navigation
      'TabBar': const TabBarScreen(),
      'BottomNavigation': const BottomNavScreen(),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Widget App'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Text(
              'App Layout Widgets: Total (${pages.length})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: pages.length,
              itemBuilder: (context, index) {
                final title = pages.keys.elementAt(index);
                final page = pages.values.elementAt(index);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.widgets,
                      color: Colors.blue,
                    ),
                    title: Text(title),
                    subtitle: Text(
                      "Let's explore the $title widget",
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => page,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
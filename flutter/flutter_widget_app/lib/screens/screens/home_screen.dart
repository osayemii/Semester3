import 'package:flutter/material.dart';

//appbar-Navigation
import 'alert_dialog_screen.dart';
import 'align_screen.dart';
import 'appbar_screen.dart';
import 'column_screen.dart';
import 'container_screen.dart';
import 'datepicker_screen.dart';
import 'icon_screen.dart';
import 'tabbar_screen.dart';
import 'text_screen.dart';
// import './bottom_nav_screen.dart';

//image
// import '../image_screen.dart';

//buttons
// import 'elevated_button_screen.dart';
import 'fab_screen.dart';
//dialogs

//form
// import '../form_screen.dart';
//text
//container
import 'padding_screen.dart';
import 'checkbox_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = {
      //Navigation
      'Alert Dialog': const AlertDialogScreen(),
      'Align': const AlignScreen(),
      'AppBar': const AppbarScreen(),
      'TabBar': const TabBarScreen(),
      // 'BottomNavigation': const BottomNavScreen(),
      // 'Elevated Button': const ElevatedButtonScreen(),
      // 'Image': const ImageScreen(),
      // 'Form': const FormScreen(),
      'Checkbox': const CheckboxScreen(),
      'Column': const ColumnScreen(),
      'Container': const ContainerScreen(),
      'Date Picker': const DatePickerScreen(),
      'Floatin Action Button': const FabScreen(),
      'Icon': const IconScreen(),
      'Padding': const PaddingScreen(),
      'Text': const TextScreen(),
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
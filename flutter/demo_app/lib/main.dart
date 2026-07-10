import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Learn flutter now!!",
      showSemanticsDebugger: false,
      home: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter App'),
      ),

      body: Center(
        child: Text('Hello World'),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black,),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.black,),
            label: 'Chat'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update, color: Colors.black,),
            label: 'Update'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.black,),
            label: 'Settings'
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          
        }),
        child: Icon(Icons.add),
      ),

      floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,

      drawer: Drawer(
        elevation: 20.0,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Flutter Learning'),
              accountEmail: Text('flutterlearning@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text('Rose'),
              ),
            ),

            ListTile(
              title: Text('Inbox'),
              leading: Icon(Icons.mail),
            ),

            Divider(
              height: 0.1,
            ),

            ListTile(
              title: Text('Primary'),
              leading: Icon(Icons.inbox),
            ),

            ListTile(
              title: Text('Social'),
              leading: Icon(Icons.people),
            ),

            ListTile(
              title: Text('Promotions'),
              leading: Icon(Icons.local_offer),
            ),
          ],
        ),
      ),
    );
  }
}
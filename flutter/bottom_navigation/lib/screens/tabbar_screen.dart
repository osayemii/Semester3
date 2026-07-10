import "package:bottom_navigation/screens/container_screen.dart";
import "package:flutter/material.dart";

List<String> profileInfo = [
  "Name: Osayemi Daniel",
  "Email: osayemidanniel@gmail.com",
  "Phone: +234 123 456 7890",
  "Address: 123 Main Street, Lagos, Nigeria",
];

List<String> chatNames = [
  "Basir",
  "Daniel E.",
  "Osayemi",
  "Heavenly",
  "Prince",
  "Ugochukwu",
  "Tumi",
  "Jemimma",
];

class TabBarScreen extends StatelessWidget {
  const TabBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Matches the 3 tabs and 3 body children below
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TabBar Example'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'Profile'),
              Tab(icon: Icon(Icons.chat), text: 'Chats'),
              Tab(icon: Icon(Icons.settings), text: 'Settings'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 1. Profile Tab: Displays all profile fields
            ListView.builder(
              itemCount: profileInfo.length,
              itemBuilder: (context, idx) {
                return ListTile(title: Text(profileInfo[idx]));
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContainerScreen(),
                  ),
                );
              },
              child: const Text('Press me!'),
            ),

            // 2. Chats Tab: Displays all chat names dynamically
            ListView.builder(
              itemCount: chatNames.length,
              itemBuilder: (context, idx) {
                return ListTile(
                  leading: const Icon(Icons.chat),
                  title: Text(chatNames[idx]),
                  trailing: const Icon(Icons.arrow_forward_ios),
                );
              },
            ),

            // 3. Settings Tab
            const Center(child: Text('Settings Page')),
          ],
        ),
      ),
    );
  }
}

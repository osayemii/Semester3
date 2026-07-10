import 'package:flutter/material.dart';

import '../services/auth_service.dart';

// Shared app bar + drawer nav, equivalent to the web app's WEB-INF/jspf/nav.jsp
// include: same links (Dashboard / Staff / Menu items / Orders / Logout) on
// every signed-in screen.
class BakeryScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;

  const BakeryScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await AuthService().logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF6B4226)),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Artisan Bakery',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            _NavTile(icon: Icons.dashboard, label: 'Dashboard', route: '/dashboard'),
            _NavTile(icon: Icons.people, label: 'Staff', route: '/staff'),
            _NavTile(icon: Icons.cake, label: 'Menu items', route: '/product'),
            _NavTile(icon: Icons.receipt_long, label: 'Orders', route: '/order'),
          ],
        ),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const _NavTile({required this.icon, required this.label, required this.route});

  @override
  Widget build(BuildContext context) {
    final isActive = ModalRoute.of(context)?.settings.name == route;
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: isActive,
      onTap: () {
        Navigator.pop(context); // close the drawer
        if (!isActive) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}

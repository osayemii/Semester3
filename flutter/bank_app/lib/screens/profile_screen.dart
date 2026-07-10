import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatelessWidget {
	final String username;

	const ProfileScreen({super.key, required this.username});

	@override
	Widget build(BuildContext context) {
		final settings = [
			{'title': 'Personal Information', 'icon': Icons.badge},
			{'title': 'Security', 'icon': Icons.lock, 'style': TextStyle(color: Colors.red)},
			{'title': 'Notifications', 'icon': Icons.notifications},
			{'title': 'Help & Support', 'icon': Icons.help},
			{'title': 'Logout', 'icon': Icons.logout},
		];

		return Padding(
			padding: const EdgeInsets.all(12),
			child: Column(
				children: [
					Container(
						width: double.infinity,
						padding: const EdgeInsets.all(8),
						child: ListTile(
							leading: const CircleAvatar(
								radius: 22,
								backgroundImage: NetworkImage(
									'https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=200',
								),
							),
							title: Text(username),
							subtitle: const Text('Account Holder'),
						),
					),
					Expanded(
						child: ListView.builder(
							itemCount: settings.length,
							itemBuilder: (context, index) {
								final item = settings[index];
								final isLogout = index == settings.length - 1;
								final titleStyle = item['style'] as TextStyle?;

								return Card(
									child: ListTile(
										leading: Icon(item['icon'] as IconData),
										title: Text(
											item['title'] as String,
											style: titleStyle,
										),
										onTap: () {
											if (isLogout) {
												SystemNavigator.pop();
											}
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

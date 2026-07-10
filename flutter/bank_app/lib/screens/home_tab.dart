import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
	final String username;

	const HomeTab({super.key, required this.username});

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: const EdgeInsets.all(16),
			child: ListView(
				children: [
					Text(
						'Welcome, $username',
						style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
					),
					const SizedBox(height: 16),
					const Card(
						child: ListTile(
							title: Text('Account Balance'),
							subtitle: Text('\$ 125,000.00'),
							trailing: Icon(Icons.account_balance_wallet),
						),
					),
					const SizedBox(height: 8),
					const Card(
						child: ListTile(
							title: Text('Quick Action'),
							subtitle: Text('Transfer, Pay Bills, Mobile Load'),
							trailing: Icon(Icons.flash_on),
						),
					),
				],
			),
		);
	}
}

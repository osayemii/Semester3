import 'package:flutter/material.dart';

class TransactionDetailScreen extends StatelessWidget {
	final Map<String, String> transaction;

	const TransactionDetailScreen({super.key, required this.transaction});

	@override
	Widget build(BuildContext context) {
		Widget row(String label, String value) {
			return Padding(
				padding: const EdgeInsets.symmetric(vertical: 8),
				child: Row(
					children: [
						SizedBox(
							width: 110,
							child: Text(
								'$label:',
								style: const TextStyle(fontWeight: FontWeight.bold),
							),
						),
						Expanded(child: Text(value)),
					],
				),
			);
		}

		return Scaffold(
			appBar: AppBar(
				title: const Text('Transaction Details'),
			),
			body: Padding(
				padding: const EdgeInsets.all(16),
				child: Column(
					children: [
						row('ID', transaction['id'] ?? ''),
						row('Title', transaction['title'] ?? ''),
						row('Date', transaction['date'] ?? ''),
						row('Amount', transaction['amount'] ?? ''),
						row('Status', transaction['status'] ?? ''),
						const SizedBox(height: 20),
						ElevatedButton(
							onPressed: () => Navigator.pop(context),
							child: const Text('Back'),
						),
					],
				),
			),
		);
	}
}

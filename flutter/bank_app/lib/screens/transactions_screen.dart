import 'package:flutter/material.dart';
import 'transaction_details_screen.dart';

class TransactionsScreen extends StatelessWidget {
	final String username;

	const TransactionsScreen({super.key, required this.username});

	@override
	Widget build(BuildContext context) {
		final transactions = [
			{
				'id': 'TXN-1001',
				'title': 'Grocery Store',
				'date': '2026-06-17',
				'amount': '- PKR 4,500',
				'status': 'Completed',
			},
			{
				'id': 'TXN-1002',
				'title': 'Salary Credit',
				'date': '2026-06-15',
				'amount': '+ PKR 85,000',
				'status': 'Completed',
			},
			{
				'id': 'TXN-1003',
				'title': 'Electricity Bill',
				'date': '2026-06-12',
				'amount': '- PKR 8,200',
				'status': 'Completed',
			},
			{
				'id': 'TXN-1004',
				'title': 'Online Shopping',
				'date': '2026-06-10',
				'amount': '- PKR 6,300',
				'status': 'Pending',
			},
		];

		return ListView.separated(
			padding: const EdgeInsets.all(12),
			itemCount: transactions.length,
			separatorBuilder: (_, __) => const SizedBox(height: 6),
			itemBuilder: (context, index) {
				final tx = transactions[index];

				return Card(
					child: ListTile(
						title: Text(tx['title']!),
						subtitle: Text('${tx['date']} • ${tx['status']}'),
						trailing: Text(tx['amount']!),
						onTap: () {
							Navigator.push(
								context,
								MaterialPageRoute(
									builder: (_) => TransactionDetailScreen(transaction: tx),
								),
							);
						},
					),
				);
			},
		);
	}
}

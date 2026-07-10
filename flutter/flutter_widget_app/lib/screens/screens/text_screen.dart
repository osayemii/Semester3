import 'package:flutter/material.dart';

class TextScreen extends StatelessWidget {
	const TextScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Text Widget'),
			),
			body: const Center(
				child: Text(
					'This is a sample Text widget.',
					style: TextStyle(
						fontSize: 24,
						fontWeight: FontWeight.bold,
					),
				),
			),
		);
	}
}

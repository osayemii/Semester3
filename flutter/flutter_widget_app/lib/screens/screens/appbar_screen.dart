import 'package:flutter/material.dart';

class AppbarScreen extends StatelessWidget {
	const AppbarScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('AppBar Widget'),
			),
			body: const Center(
				child: Text('This page demonstrates a basic AppBar.'),
			),
		);
	}
}

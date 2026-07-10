import 'package:flutter/material.dart';

import '../theme/bakery_theme.dart';

// Mirrors the web app's .stat-card in dashboard.jsp.
class StatCard extends StatelessWidget {
  final String label;
  final String value;

  const StatCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: const Border(left: BorderSide(color: BakeryColors.amber, width: 5)),
        boxShadow: const [
          BoxShadow(color: Color(0x1F6B4226), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: BakeryColors.brown,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              letterSpacing: 0.5,
              color: Color(0xFF8A6A4D),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

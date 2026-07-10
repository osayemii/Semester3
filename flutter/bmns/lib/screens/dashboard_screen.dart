import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/staff_service.dart';
import '../services/product_service.dart';
import '../services/order_service.dart';
import '../models/staff.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../theme/bakery_theme.dart';
import '../widgets/bakery_scaffold.dart';
import '../widgets/stat_card.dart';

// Equivalent of dashboard.jsp — live counts + total revenue, computed from
// the same three streams the list screens use.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final staffService = StaffService();
  final productService = ProductService();
  final orderService = OrderService();

  // Created once so rebuilds don't spin up fresh polling streams each time.
  late final Stream<List<Staff>> _staffStream = staffService.getStaffStream();
  late final Stream<List<Product>> _productStream = productService.getProductStream();
  late final Stream<List<Order>> _orderStream = orderService.getOrderStream();

  @override
  void initState() {
    super.initState();
    // Same guard the servlets apply server-side: no signed-in user, no page.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (FirebaseAuth.instance.currentUser == null && mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';

    return BakeryScaffold(
      title: 'Dashboard',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Artisan Bakery',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: BakeryColors.brown),
            ),
            const SizedBox(height: 4),
            Text('Signed in as $email', style: const TextStyle(color: Color(0xFF8A6A4D))),
            const SizedBox(height: 20),

            StreamBuilder<List<Staff>>(
              stream: _staffStream,
              builder: (context, staffSnap) {
                final staffCount = staffSnap.data?.length ?? 0;
                return StreamBuilder<List<Product>>(
                  stream: _productStream,
                  builder: (context, productSnap) {
                    final productCount = productSnap.data?.length ?? 0;
                    return StreamBuilder<List<Order>>(
                      stream: _orderStream,
                      builder: (context, orderSnap) {
                        final orders = orderSnap.data ?? [];
                        final orderCount = orders.length;
                        final revenue = orders.fold<double>(0, (sum, o) => sum + o.totalPrice);

                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 1.6,
                          children: [
                            StatCard(label: 'Staff members', value: '$staffCount'),
                            StatCard(label: 'Menu items', value: '$productCount'),
                            StatCard(label: 'Orders', value: '$orderCount'),
                            StatCard(label: 'Total revenue', value: '\$${revenue.toStringAsFixed(2)}'),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 24),
            const Text('Quick links', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: BakeryColors.brown)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/staff'),
                  icon: const Icon(Icons.people),
                  label: const Text('Manage staff'),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/product'),
                  icon: const Icon(Icons.cake),
                  label: const Text('Manage menu items'),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/order'),
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('Manage orders'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

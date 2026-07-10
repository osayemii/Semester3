import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/order.dart';
import '../services/order_service.dart';
import '../theme/bakery_theme.dart';
import '../widgets/bakery_scaffold.dart';

// Equivalent of order.jsp + OrderServlet: live list + add/edit/delete
// for customer orders.
class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final orderService = OrderService();
  // Created once so rebuilds don't spin up a fresh polling stream each time.
  late final Stream<List<Order>> _orderStream = orderService.getOrderStream();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (FirebaseAuth.instance.currentUser == null && mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  Future<void> _openForm({Order? existing}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _OrderFormSheet(orderService: orderService, existing: existing),
    );
  }

  Future<void> _confirmDelete(Order order) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete order?'),
        content: Text('Remove the order for ${order.customerName}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: BakeryColors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && order.id != null) {
      try {
        await orderService.delete(order.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order deleted.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not delete: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BakeryScaffold(
      title: 'Orders',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Order>>(
        stream: _orderStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final orderList = snapshot.data!;
          if (orderList.isEmpty) {
            return const Center(child: Text('No orders yet. Tap + to add one.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              final o = orderList[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(o.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${o.productName} — ${o.orderedGoods}\n\$${o.totalPrice.toStringAsFixed(2)} · ${o.orderedDate}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: BakeryColors.amberDark),
                        onPressed: () => _openForm(existing: o),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: BakeryColors.red),
                        onPressed: () => _confirmDelete(o),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _OrderFormSheet extends StatefulWidget {
  final OrderService orderService;
  final Order? existing;

  const _OrderFormSheet({required this.orderService, this.existing});

  @override
  State<_OrderFormSheet> createState() => _OrderFormSheetState();
}

class _OrderFormSheetState extends State<_OrderFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController customerNameCtrl;
  late final TextEditingController productNameCtrl;
  late final TextEditingController orderedGoodsCtrl;
  late final TextEditingController totalPriceCtrl;
  DateTime? orderedDate;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    customerNameCtrl = TextEditingController(text: e?.customerName ?? '');
    productNameCtrl = TextEditingController(text: e?.productName ?? '');
    orderedGoodsCtrl = TextEditingController(text: e?.orderedGoods ?? '');
    totalPriceCtrl = TextEditingController(text: e != null ? e.totalPrice.toString() : '');
    if (e != null && e.orderedDate.isNotEmpty) {
      orderedDate = DateTime.tryParse(e.orderedDate);
    }
  }

  @override
  void dispose() {
    customerNameCtrl.dispose();
    productNameCtrl.dispose();
    orderedGoodsCtrl.dispose();
    totalPriceCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: orderedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => orderedDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (orderedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pick an order date.')),
      );
      return;
    }
    setState(() => isSaving = true);

    final isoDate =
        '${orderedDate!.year.toString().padLeft(4, '0')}-${orderedDate!.month.toString().padLeft(2, '0')}-${orderedDate!.day.toString().padLeft(2, '0')}';

    final order = Order(
      id: widget.existing?.id,
      customerName: customerNameCtrl.text.trim(),
      productName: productNameCtrl.text.trim(),
      orderedGoods: orderedGoodsCtrl.text.trim(),
      totalPrice: double.parse(totalPriceCtrl.text.trim()),
      orderedDate: isoDate,
    );

    try {
      if (widget.existing == null) {
        await widget.orderService.add(order);
      } else {
        await widget.orderService.update(order);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? 'Update order' : 'Save order',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: BakeryColors.brown),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: customerNameCtrl,
                decoration: const InputDecoration(labelText: 'Customer name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: productNameCtrl,
                decoration: const InputDecoration(labelText: 'Item / product name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: orderedGoodsCtrl,
                decoration: const InputDecoration(labelText: 'Details (e.g. dozen croissants)'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: totalPriceCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Total price'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (double.tryParse(v.trim()) == null) return 'Enter a number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Order date'),
                  child: Text(
                    orderedDate == null
                        ? 'Tap to choose a date'
                        : '${orderedDate!.year}-${orderedDate!.month.toString().padLeft(2, '0')}-${orderedDate!.day.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSaving ? null : _save,
                  child: isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(isEdit ? 'Update order' : 'Save order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

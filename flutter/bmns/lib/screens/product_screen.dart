import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import '../theme/bakery_theme.dart';
import '../widgets/bakery_scaffold.dart';

// Equivalent of product.jsp + ProductServlet: live list + add/edit/delete
// for menu items.
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final productService = ProductService();
  // Created once so rebuilds don't spin up a fresh polling stream each time.
  late final Stream<List<Product>> _productStream = productService.getProductStream();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (FirebaseAuth.instance.currentUser == null && mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  Future<void> _openForm({Product? existing}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ProductFormSheet(productService: productService, existing: existing),
    );
  }

  Future<void> _confirmDelete(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete menu item?'),
        content: Text('Remove ${product.name} from the menu?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: BakeryColors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && product.id != null) {
      try {
        await productService.delete(product.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Menu item deleted.')),
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
      title: 'Menu items',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Product>>(
        stream: _productStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final productList = snapshot.data!;
          if (productList.isEmpty) {
            return const Center(child: Text('No menu items yet. Tap + to add one.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: productList.length,
            itemBuilder: (context, index) {
              final p = productList[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('\$${p.price.toStringAsFixed(2)} · Qty ${p.quantity}\nProduced ${p.productionDate}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: BakeryColors.amberDark),
                        onPressed: () => _openForm(existing: p),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: BakeryColors.red),
                        onPressed: () => _confirmDelete(p),
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

class _ProductFormSheet extends StatefulWidget {
  final ProductService productService;
  final Product? existing;

  const _ProductFormSheet({required this.productService, this.existing});

  @override
  State<_ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends State<_ProductFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameCtrl;
  late final TextEditingController priceCtrl;
  late final TextEditingController quantityCtrl;
  DateTime? productionDate;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    nameCtrl = TextEditingController(text: e?.name ?? '');
    priceCtrl = TextEditingController(text: e != null ? e.price.toString() : '');
    quantityCtrl = TextEditingController(text: e != null ? '${e.quantity}' : '');
    if (e != null && e.productionDate.isNotEmpty) {
      productionDate = DateTime.tryParse(e.productionDate);
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    quantityCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: productionDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => productionDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (productionDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pick a production date.')),
      );
      return;
    }
    setState(() => isSaving = true);

    final isoDate =
        '${productionDate!.year.toString().padLeft(4, '0')}-${productionDate!.month.toString().padLeft(2, '0')}-${productionDate!.day.toString().padLeft(2, '0')}';

    final product = Product(
      id: widget.existing?.id,
      name: nameCtrl.text.trim(),
      price: double.parse(priceCtrl.text.trim()),
      quantity: int.parse(quantityCtrl.text.trim()),
      productionDate: isoDate,
    );

    try {
      if (widget.existing == null) {
        await widget.productService.add(product);
      } else {
        await widget.productService.update(product);
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
                isEdit ? 'Update item' : 'Add item',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: BakeryColors.brown),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Item name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (double.tryParse(v.trim()) == null) return 'Enter a number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: quantityCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity in stock'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (int.tryParse(v.trim()) == null) return 'Enter a whole number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Bake / production date'),
                  child: Text(
                    productionDate == null
                        ? 'Tap to choose a date'
                        : '${productionDate!.year}-${productionDate!.month.toString().padLeft(2, '0')}-${productionDate!.day.toString().padLeft(2, '0')}',
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
                      : Text(isEdit ? 'Update item' : 'Add item'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

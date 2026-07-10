import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/staff.dart';
import '../services/staff_service.dart';
import '../theme/bakery_theme.dart';
import '../widgets/bakery_scaffold.dart';

// Equivalent of staff.jsp + StaffServlet: live list + add/edit/delete.
class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  final staffService = StaffService();
  // Created once (not inside build()) so rebuilds don't spin up a fresh
  // polling stream each time — same reasoning ClassChatApp's ChatScreen
  // documents for why it manages its subscription manually.
  late final Stream<List<Staff>> _staffStream = staffService.getStaffStream();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (FirebaseAuth.instance.currentUser == null && mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  Future<void> _openForm({Staff? existing}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _StaffFormSheet(staffService: staffService, existing: existing),
    );
  }

  Future<void> _confirmDelete(Staff staff) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete staff member?'),
        content: Text('Remove ${staff.name} from staff?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: BakeryColors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && staff.id != null) {
      try {
        await staffService.delete(staff.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Staff member deleted.')),
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
      title: 'Staff',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Staff>>(
        stream: _staffStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final staffList = snapshot.data!;
          if (staffList.isEmpty) {
            return const Center(child: Text('No staff yet. Tap + to add one.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: staffList.length,
            itemBuilder: (context, index) {
              final s = staffList[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${s.email}\nAge ${s.age} · ${s.phone}\n${s.address}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: BakeryColors.amberDark),
                        onPressed: () => _openForm(existing: s),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: BakeryColors.red),
                        onPressed: () => _confirmDelete(s),
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

class _StaffFormSheet extends StatefulWidget {
  final StaffService staffService;
  final Staff? existing;

  const _StaffFormSheet({required this.staffService, this.existing});

  @override
  State<_StaffFormSheet> createState() => _StaffFormSheetState();
}

class _StaffFormSheetState extends State<_StaffFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController ageCtrl;
  late final TextEditingController phoneCtrl;
  late final TextEditingController addressCtrl;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    nameCtrl = TextEditingController(text: e?.name ?? '');
    emailCtrl = TextEditingController(text: e?.email ?? '');
    ageCtrl = TextEditingController(text: e != null ? '${e.age}' : '');
    phoneCtrl = TextEditingController(text: e?.phone ?? '');
    addressCtrl = TextEditingController(text: e?.address ?? '');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    ageCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isSaving = true);

    final staff = Staff(
      id: widget.existing?.id,
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      age: int.parse(ageCtrl.text.trim()),
      phone: phoneCtrl.text.trim(),
      address: addressCtrl.text.trim(),
    );

    try {
      if (widget.existing == null) {
        await widget.staffService.add(staff);
      } else {
        await widget.staffService.update(staff);
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
                isEdit ? 'Update staff' : 'Add staff',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: BakeryColors.brown),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: ageCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (int.tryParse(v.trim()) == null) return 'Enter a whole number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: addressCtrl,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
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
                      : Text(isEdit ? 'Update staff' : 'Add staff'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

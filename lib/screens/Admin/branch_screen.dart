import 'package:flutter/material.dart';
import '../../../models/branch_model.dart';
import '../../../services/branch_service.dart';
import 'branch_edit_screen.dart';
import 'branch_create_screen.dart';

class BranchScreen extends StatefulWidget {
  const BranchScreen({super.key});

  @override
  State<BranchScreen> createState() => _BranchScreenState();
}

class _BranchScreenState extends State<BranchScreen> {
  List<Branch> _branches = [];

  @override
  void initState() {
    super.initState();
    fetchBranches();
  }

  Future<void> fetchBranches() async {
    try {
      final branches = await BranchService.getAllBranches();
      setState(() {
        _branches = branches;
      });
    } catch (e) {
      print("Error loading branches: $e");
    }
  }

  void _deleteBranch(String id) async {
    await BranchService.deleteBranch(id);
    fetchBranches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Branch Management')),
      body: ListView.builder(
        itemCount: _branches.length,
        itemBuilder: (context, index) {
          final branch = _branches[index];
          return ListTile(
            title: Text(branch.tenChiNhanh),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${branch.diaChi} - ${branch.sdt}'),
                Text(
                  branch.status ? '🟢 Active' : '🔴 Inactive',
                  style: TextStyle(
                    color: branch.status ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BranchEditScreen(branch: branch),
                      ),
                    );
                    if (result == true) fetchBranches();
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BranchCreateScreen()),
          );
          if (result == true) fetchBranches(); // Reload sau khi thêm
        },
      ),
    );
  }
}

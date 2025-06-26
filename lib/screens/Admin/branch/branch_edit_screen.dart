import 'package:flutter/material.dart';
import '../../../../models/branch_model.dart';
import '../../../../services/branch_service.dart';

class BranchEditScreen extends StatefulWidget {
  final Branch branch;

  const BranchEditScreen({super.key, required this.branch});

  @override
  State<BranchEditScreen> createState() => _BranchEditScreenState();
}

class _BranchEditScreenState extends State<BranchEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tenChiNhanhController;
  late TextEditingController _diaChiController;
  late TextEditingController _sdtController;
  bool _status = true;

  @override
  void initState() {
    super.initState();
    _tenChiNhanhController = TextEditingController(
      text: widget.branch.tenChiNhanh,
    );
    _diaChiController = TextEditingController(text: widget.branch.diaChi);
    _sdtController = TextEditingController(text: widget.branch.sdt);
    _status = widget.branch.status;
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final updatedBranch = Branch(
        id: widget.branch.id,
        tenChiNhanh: _tenChiNhanhController.text.trim(),
        diaChi: _diaChiController.text.trim(),
        sdt: _sdtController.text.trim(),
        status: _status,
      );

      await BranchService.updateBranch(updatedBranch);
      Navigator.pop(context, true); // Quay về với tín hiệu reload
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sửa Chi Nhánh')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tenChiNhanhController,
                decoration: const InputDecoration(labelText: 'Tên chi nhánh'),
                validator:
                    (value) => value!.isEmpty ? 'Không được để trống' : null,
              ),
              TextFormField(
                controller: _diaChiController,
                decoration: const InputDecoration(labelText: 'Địa chỉ'),
                validator:
                    (value) => value!.isEmpty ? 'Không được để trống' : null,
              ),
              TextFormField(
                controller: _sdtController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
              ),
              SwitchListTile(
                value: _status,
                title: const Text('Trạng thái'),
                onChanged: (val) => setState(() => _status = val),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Lưu thay đổi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

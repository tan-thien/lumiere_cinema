import 'package:flutter/material.dart';
import '../../../../models/branch_model.dart';
import '../../../../services/branch_service.dart';

class BranchCreateScreen extends StatefulWidget {
  const BranchCreateScreen({super.key});

  @override
  State<BranchCreateScreen> createState() => _BranchCreateScreenState();
}

class _BranchCreateScreenState extends State<BranchCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tenChiNhanhController = TextEditingController();
  final _diaChiController = TextEditingController();
  final _sdtController = TextEditingController();
  bool _trangThai = true;

  void _createBranch() async {
    if (_formKey.currentState!.validate()) {
      final newBranch = Branch(
        id: '',
        tenChiNhanh: _tenChiNhanhController.text,
        diaChi: _diaChiController.text,
        sdt: _sdtController.text,
        status: _trangThai,
      );

      try {
        await BranchService.createBranch(newBranch);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi tạo chi nhánh: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm chi nhánh')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tenChiNhanhController,
                decoration: const InputDecoration(labelText: 'Tên chi nhánh'),
                validator:
                    (value) => value!.isEmpty ? 'Nhập tên chi nhánh' : null,
              ),
              TextFormField(
                controller: _diaChiController,
                decoration: const InputDecoration(labelText: 'Địa chỉ'),
                validator: (value) => value!.isEmpty ? 'Nhập địa chỉ' : null,
              ),
              TextFormField(
                controller: _sdtController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                validator:
                    (value) => value!.isEmpty ? 'Nhập số điện thoại' : null,
              ),
              SwitchListTile(
                title: const Text('Trạng thái'),
                value: _trangThai,
                onChanged: (value) {
                  setState(() => _trangThai = value);
                },
              ),
              ElevatedButton(
                onPressed: _createBranch,
                child: const Text('Tạo chi nhánh'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

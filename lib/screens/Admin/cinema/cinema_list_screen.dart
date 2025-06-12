import 'package:flutter/material.dart';
import '../../../models/cinema.dart';
import '../../../models/branch_model.dart';
import '../../../services/cinema_service.dart';
import '../../../services/branch_service.dart';
import 'cinema_form_screen.dart';
import 'cinema_edit_screen.dart';

class CinemaListScreen extends StatefulWidget {
  @override
  _CinemaListScreenState createState() => _CinemaListScreenState();
}

class _CinemaListScreenState extends State<CinemaListScreen> {
  final CinemaService _cinemaService = CinemaService();
  Future<List<Cinema>>? _cinemas; // không dùng late
  Map<String, String> _branchMap = {}; // Map<id, tenChiNhanh>

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final branches = await BranchService.getAllBranches();
    final cinemasFuture = _cinemaService.getAllCinemas();

    _branchMap = {for (var b in branches) b.id!: b.tenChiNhanh};

    setState(() {
      _cinemas = cinemasFuture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách rạp")),
      body:
          _cinemas == null
              ? Center(child: CircularProgressIndicator()) // chờ init
              : FutureBuilder<List<Cinema>>(
                future: _cinemas,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  if (snapshot.hasError)
                    return Center(child: Text("Lỗi: ${snapshot.error}"));

                  final cinemas = snapshot.data!;
                  return ListView.builder(
                    itemCount: cinemas.length,
                    itemBuilder: (context, index) {
                      final cinema = cinemas[index];
                      final branchName =
                          _branchMap[cinema.maChiNhanh] ?? 'Không rõ';

                      return ListTile(
                        leading: Icon(
                          cinema.trangThai ? Icons.check_circle : Icons.cancel,
                          color: cinema.trangThai ? Colors.green : Colors.red,
                        ),
                        title: Text(cinema.tenRap),
                        subtitle: Text(
                          "Ghế: ${cinema.soLuongGhe} | Chi nhánh: $branchName",
                        ),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CinemaEditScreen(cinema: cinema),
                            ),
                          );
                          if (result == true) {
                            setState(() {
                              _cinemas = _cinemaService.getAllCinemas();
                            });
                          }
                        },
                      );
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CinemaFormScreen()),
          );
          if (result == true) {
            setState(() {
              _cinemas = _cinemaService.getAllCinemas();
            });
          }
        },
      ),
    );
  }
}

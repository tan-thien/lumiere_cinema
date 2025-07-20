import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '/models/branch_model.dart';
import '/services/branch_service.dart';

class CinemaScreen extends StatefulWidget {
  const CinemaScreen({super.key});

  @override
  State<CinemaScreen> createState() => _CinemaScreenState();
}

class _CinemaScreenState extends State<CinemaScreen> {
  late Future<List<Branch>> _branchesFuture;

  @override
  void initState() {
    super.initState();
    _branchesFuture = BranchService.getAllBranches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng


appBar: AppBar(
  title: const Text('Danh sách rạp chiếu'),
  centerTitle: true,
  backgroundColor: Colors.transparent, // 👈 Trong suốt
  elevation: 0,
  foregroundColor: Colors.black,
  systemOverlayStyle: SystemUiOverlayStyle.dark,
  flexibleSpace: ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // 👈 Đủ mờ, không quá nặng
      child: Container(
        color: Colors.white.withOpacity(0.0), // 👈 0.0 = hoàn toàn trong suốt
      ),
    ),
  ),
  automaticallyImplyLeading: false, // 👈 Xóa nút back
),


      body: FutureBuilder<List<Branch>>(
        future: _branchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Không có chi nhánh nào',
                style: TextStyle(color: Colors.black54),
              ),
            );
          }

          final branches = snapshot.data!;

          final imageUrls = [
            'https://kenh14cdn.com/Images/Uploaded/Share/2012/01/09/120110CineLote02.jpg',
            'https://www.galaxycine.vn/media/2023/4/28/imax---copy_1682666076363.jpg',
            'https://www.lottecinemavn.com/LCCS/Image/thum/img_lotte01_2.jpg',
            'https://happyvivu.com/wp-content/uploads/2023/11/CGV-5.png',
          ];

          return ListView.builder(
            itemCount: branches.length +1,
            itemBuilder: (context, index) {

              if(index == branches.length){
                return const SizedBox(height: 90);
              }
              final branch = branches[index];
              final imageUrl = imageUrls[index % imageUrls.length]; // lặp ảnh

              return Card(
                color: Colors.grey[100],
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.error),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            branch.tenChiNhanh,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Địa chỉ: ${branch.diaChi}',
                            style: const TextStyle(color: Colors.black87),
                          ),
                          Text(
                            'SĐT: ${branch.sdt}',
                            style: const TextStyle(color: Colors.black87),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Trạng thái: ${branch.status ? "Hoạt động" : "Không hoạt động"}',
                            style: TextStyle(
                              color:
                                  branch.status
                                      ? Colors.green[700]
                                      : Colors.red[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      
    );
  }
}

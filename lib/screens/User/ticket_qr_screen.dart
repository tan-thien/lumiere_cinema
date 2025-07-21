import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketQRScreen extends StatelessWidget {
  final String ticketId;

  const TicketQRScreen({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mã QR của vé'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // QR code + nền vé
            Container(
  padding: const EdgeInsets.all(4), // Độ dày của viền
  decoration: BoxDecoration(
    border: Border.all(color: Colors.orange, width: 3),
    borderRadius: BorderRadius.circular(24),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Stack(
      alignment: Alignment.center,
      children: [
        // Nền vé phim
        Image.asset(
          'assets/images/ticket.png',
          width: 235 ,
          height: 313 ,
          fit: BoxFit.cover,
        ),

        // QR Code đè lên nền vé
        Container(
          padding: const EdgeInsets.all(8),
          child: QrImageView(
            data: ticketId,
            version: QrVersions.auto,
            size: 180.0,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.circle,
              color: Colors.black,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.circle,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  ),
),


            // const SizedBox(height: 14),

            // Mã vé
            const Text(
              'Mã vé',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 4),
            SelectableText(
              ticketId,
              style: const TextStyle(fontSize: 20, color: Colors.orange),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Nút quay lại
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Quay lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

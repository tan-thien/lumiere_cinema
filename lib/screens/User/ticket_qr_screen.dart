import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketQRScreen extends StatelessWidget {
  final String ticketId;

  const TicketQRScreen({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mã QR của vé')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: ticketId,
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 20),
            Text(
              'Mã vé: $ticketId',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

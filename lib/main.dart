import 'package:flutter/material.dart';
import 'package:lumiere_cinema/screens/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async  {
    await initializeDateFormatting('vi', null);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumiere Cinema',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
      home: const SplashScreen(), // Có token thì khỏi phải đăng nhập lại
    );
  }
}

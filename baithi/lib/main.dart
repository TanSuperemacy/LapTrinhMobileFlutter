import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  // Bắt buộc phải có dòng này khi sử dụng SQLite để tránh lỗi khởi tạo
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'UTC2 Student Management',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

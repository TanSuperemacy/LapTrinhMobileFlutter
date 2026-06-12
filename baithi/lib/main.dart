import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'utils/constants.dart';

void main() {
  // Đảm bảo Flutter framework được khởi tạo hoàn tất trước khi chạy app (đặc biệt khi dùng SQLite)
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

/// Lớp chính khởi chạy ứng dụng Quản lý Sinh viên UTC2
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng Dụng Quản Lý Sinh Viên - UTC2',
      debugShowCheckedModeBanner: false, // Tắt nhãn DEBUG ở góc màn hình
      
      // Thiết lập Theme (Chủ đề giao diện) toàn cục cho ứng dụng
      theme: ThemeData(
        useMaterial3: true, // Sử dụng thiết kế Material 3 hiện đại
        
        // Cấu hình bảng màu chuẩn xác theo yêu cầu đề thi
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.iconColor, // Màu hạt giống chủ đạo #130160
          primary: AppConstants.iconColor,
          secondary: AppConstants.buttonColor, // Màu phụ (màu nút bấm) #FF9228
          surface: AppConstants.itemColor, // Màu nền của card/item #FFFFFF
        ),
        
        // Thiết lập màu nền Scaffold toàn cục là màu xám #E5E5E5 (Yêu cầu đề bài)
        scaffoldBackgroundColor: AppConstants.backgroundColor,
        
        // Cấu hình AppBar mặc định cho toàn app
        appBarTheme: const AppBarTheme(
          backgroundColor: AppConstants.iconColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        
        // Định dạng input fields (TextFormField) đồng bộ
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppConstants.itemColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: AppConstants.borderRadius,
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppConstants.borderRadius,
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppConstants.borderRadius,
            borderSide: const BorderSide(color: AppConstants.buttonColor, width: 2),
          ),
        ),
      ),
      
      // Màn hình khởi chạy đầu tiên là Màn hình Đăng nhập (Câu 1)
      home: const LoginScreen(),
    );
  }
}

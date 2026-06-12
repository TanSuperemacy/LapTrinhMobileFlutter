import 'package:flutter/material.dart';

class ImageAssetScreen extends StatelessWidget {
  const ImageAssetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ôn tập: Image.asset'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- LÝ THUYẾT ---
            const Card(
              color: Colors.tealAccent,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 Image.asset cần lưu ý:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Phải có 2 bước:\n'
                      '  Bước 1: Khai báo thư mục hoặc đường dẫn ảnh trong file pubspec.yaml.\n'
                      '  Bước 2: Sử dụng widget Image.asset("đường_dẫn_ảnh") trong code.\n'
                      '• Ví dụ khai báo pubspec.yaml:\n'
                      '  flutter:\n'
                      '    assets:\n'
                      '      - assets/images/sample.png (hoặc assets/images/ để lấy toàn bộ ảnh trong thư mục đó)',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- DEMO ---
            const Text(
              '🎮 Demo thực tế:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/sample.png',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Hình ảnh được tải cục bộ từ thư mục assets/images/sample.png'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            // --- CODE CHAY ĐỂ HỌC ---
            const Text(
              '📝 Mẫu code chay tối giản nhất:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: const Text(
                '// 1. Dùng trực tiếp trong build:\n'
                'Image.asset(\n'
                '  "assets/images/sample.png",\n'
                '  width: 200,\n'
                '  height: 200,\n'
                '  fit: BoxFit.cover,\n'
                ')\n\n'
                '// 2. Chú ý khai báo ở pubspec.yaml:\n'
                '// flutter:\n'
                '//   assets:\n'
                '//     - assets/images/sample.png',
                style: TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

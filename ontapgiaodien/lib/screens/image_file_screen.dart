import 'dart:io';
import 'package:flutter/material.dart';

class ImageFileScreen extends StatefulWidget {
  const ImageFileScreen({super.key});

  @override
  State<ImageFileScreen> createState() => _ImageFileScreenState();
}

class _ImageFileScreenState extends State<ImageFileScreen> {
  // Biến chứa đường dẫn file ảnh
  String? _filePath;
  bool _fileExists = false;

  @override
  void initState() {
    super.initState();
    // Tạo đường dẫn tương đối tới ảnh đã lưu trên máy
    _filePath = 'assets/images/sample_file.png';
    _checkFileExists();
  }

  void _checkFileExists() {
    final file = File(_filePath!);
    setState(() {
      _fileExists = file.existsSync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ôn tập: Image.file'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- LÝ THUYẾT ---
            const Card(
              color: Colors.cyanAccent,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 Image.file cần lưu ý:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Import thư viện hệ thống: import \'dart:io\'; để sử dụng lớp File.\n'
                      '• Cú pháp hiển thị: Image.file(File(path))\n'
                      '• Thường được dùng khi chụp ảnh từ Camera hoặc chọn ảnh từ Album Gallery bằng package image_picker.\n'
                      '• Lưu ý: Trên các hệ điều hành di động, cần cấp quyền truy cập bộ nhớ hoặc camera trong AndroidManifest.xml và Info.plist.',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- DEMO ---
            const Text(
              '🎮 Demo thực tế (Đọc file từ bộ nhớ):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  _fileExists && _filePath != null
                      ? Image.file(
                          File(_filePath!),
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 250,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Text('Không tìm thấy file hoặc chưa tải'),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Đường dẫn file: $_filePath',
                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    ),
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
                '// 1. Nhớ import thư viện IO:\n'
                'import \'dart:io\';\n\n'
                '// 2. Định nghĩa biến lưu đường dẫn:\n'
                'String path = "/storage/emulated/0/.../image.jpg";\n\n'
                '// 3. Hiển thị ảnh từ File:\n'
                'Image.file(\n'
                '  File(path),\n'
                '  width: 150,\n'
                '  height: 150,\n'
                '  fit: BoxFit.cover,\n'
                ')',
                style: TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

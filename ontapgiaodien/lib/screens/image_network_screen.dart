import 'package:flutter/material.dart';

class ImageNetworkScreen extends StatelessWidget {
  const ImageNetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String imageUrl = 'https://picsum.photos/400/300';
    const String errorUrl = 'https://invalid-url-that-does-not-exist.com/image.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ôn tập: Image.network'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- LÝ THUYẾT ---
            const Card(
              color: Colors.blueAccent,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 Image.network cần lưu ý:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Cú pháp cơ bản: Image.network("link_anh")\n'
                      '• fit: BoxFit.cover (cắt vừa khung), BoxFit.contain (thu nhỏ vừa khung), BoxFit.fill (kéo giãn đè lên).\n'
                      '• Đi thi nên biết xử lý lỗi bằng errorBuilder đề phòng mất mạng hoặc link hỏng.',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- DEMO ---
            const Text(
              '🎮 Demo thực tế (Ảnh hợp lệ):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // Hiển thị vòng xoay khi đang tải ảnh
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Hình ảnh được tải từ internet (picsum.photos)'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              '🎮 Demo xử lý lỗi (Link ảnh sai):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Image.network(
                    errorUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // Xử lý khi xảy ra lỗi tải ảnh
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        color: Colors.red[50],
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, color: Colors.red, size: 40),
                              SizedBox(height: 8),
                              Text(
                                'Không tải được ảnh (Lỗi đường truyền)',
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      );
                    },
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
                '// 1. Cú pháp cơ bản nhất:\n'
                'Image.network(\n'
                '  "https://link-anh.com/image.jpg",\n'
                '  width: 100,\n'
                '  height: 100,\n'
                '  fit: BoxFit.cover,\n'
                ')\n\n'
                '// 2. Cú pháp có bắt lỗi (khuyên dùng đi thi):\n'
                'Image.network(\n'
                '  "https://link-anh.com/image.jpg",\n'
                '  errorBuilder: (context, error, stackTrace) {\n'
                '    return Text("Lỗi tải ảnh!");\n'
                '  },\n'
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
